#!/usr/bin/env -S deno run --allow-read --allow-write --allow-run --allow-net --allow-env

import { parse } from "npm:@bgotink/kdl";
import { pooledMap } from "jsr:@std/async/pool";

type ParserSpec = {
    name: string;
    repo: string;
    subdir?: string;
    rev?: string;
};

const HOME = Deno.env.get("HOME")!;
const ROOT = `${HOME}/.config/tree-sitter-parsers`;
const CONFIG = `${ROOT}/languages.kdl`;
const REPOS = `${ROOT}/repos`;
const PARSERS = `${ROOT}/parser`;
const QUERIES = `${ROOT}/queries`;
const CONCURRENCY = Math.floor(navigator.hardwareConcurrency * 0.75) || 1;

const decoder = new TextDecoder();
const encoder = new TextEncoder();
const tracker: Map<string, { status: string; ok?: boolean }> = new Map();
const libExt = (Deno.build.os === "darwin") ? "dylib" : "so";

const INHERIT_MAP: Record<string, string> = {
    ecma: "javascript",
};

// ── helpers ──────────────────────────────────────────────────────────────────

async function exists(p: string) {
    try {
        await Deno.stat(p);
        return true;
    } catch {
        return false;
    }
}

async function run(cmd: string[], cwd?: string) {
    const proc = new Deno.Command(cmd[0], {
        args: cmd.slice(1),
        cwd,
        stdout: "piped",
        stderr: "piped",
    }).spawn();

    const { code, stdout, stderr } = await proc.output();
    const out = decoder.decode(stdout);
    const err = decoder.decode(stderr);

    if (code !== 0) {
        const bits = [
            `Command failed (exit ${code}): ${cmd.join(" ")}`,
            cwd ? `  cwd: ${cwd}` : "",
            out ? `  stdout:\n${out.trimEnd()}` : "",
            err ? `  stderr:\n${err.trimEnd()}` : "",
        ];
        throw new Error(bits.filter(Boolean).join("\n"));
    }
    return { out, err };
}

// ── config parsing ───────────────────────────────────────────────────────────

async function readConfig(): Promise<ParserSpec[]> {
    const doc = parse(await Deno.readTextFile(CONFIG));
    return doc.nodes
        .filter((n: any) => n.name.name === "parser")
        .map((n: any) => {
            const name = n.entries[0]?.value?.value as string;
            const kids = n.children?.nodes ?? [];
            const repo = kids.find((c: any) => c.name.name === "repo")
                ?.entries[0]?.value?.value as string;
            const subdir = kids.find((c: any) => c.name.name === "subdir")
                ?.entries[0]?.value?.value as string | undefined;
            const rev = kids.find((c: any) => c.name.name === "rev")
                ?.entries[0]?.value?.value as string | undefined;
            return { name, repo, subdir, rev };
        });
}

// ── build steps ──────────────────────────────────────────────────────────────

async function checkout(spec: ParserSpec, dir: string) {
    if (await exists(dir)) {
        await run(["git", "-C", dir, "fetch", "--tags", "--prune", "origin"]);
    } else {
        await run(["git", "clone", spec.repo, dir]);
    }

    // Reset generated files left over from prior builds
    const { out } = await run(["git", "-C", dir, "status", "--porcelain"]);
    const gen = new Set([
        "src/parser.c",
        "src/node-types.json",
        "src/grammar.json",
        "src/tree_sitter/array.h",
        "src/tree_sitter/parser.h",
    ]);
    for (const line of out.split("\n").filter(Boolean)) {
        const code = line.slice(0, 2);
        const raw = line.slice(3);
        const path = raw.includes(" -> ") ? raw.split(" -> ").at(-1)! : raw;
        if (!gen.has(path)) continue;
        if (code === "??") {
            await Deno.remove(`${dir}/${path}`);
        } else {
            await run(["git", "-C", dir, "checkout", "--", path]);
        }
    }

    if (spec.rev) {
        await run(["git", "-C", dir, "checkout", spec.rev]);
    } else {
        await run(["git", "-C", dir, "checkout", "HEAD"]);
        await run(["git", "-C", dir, "pull", "--ff-only"]);
    }

    if (await exists(`${dir}/package.json`)) {
        const lock = await exists(`${dir}/package-lock.json`);
        await run(lock ? ["npm", "ci", "--ignore-scripts"] : ["npm", "install", "--ignore-scripts"], dir);
    }
}

async function compile(spec: ParserSpec, dir: string) {
    const work = spec.subdir ? `${dir}/${spec.subdir}` : dir;
    await run(["tree-sitter", "generate"], work);
    await run(["tree-sitter", "build", "--output", `${PARSERS}/${spec.name}.${libExt}`], work);
}

// Languages whose upstream grammar repos ship only additive queries, relying on
// nvim-treesitter's own inherits modelines. We replicate that here so Neovim's
// native treesitter picks up the base language highlighting automatically.
const QUERY_INHERITS: Record<string, Partial<Record<string, string>>> = {
    typescript:      { "highlights.scm": "javascript" },
    tsx:             { "highlights.scm": "javascript,jsx" },
    jsx:             { "highlights.scm": "javascript" },
    ocaml_interface: { "highlights.scm": "ocaml" },
};

async function installQueries(spec: ParserSpec, dir: string) {
    const work = spec.subdir ? `${dir}/${spec.subdir}` : dir;
    const src = (await exists(`${work}/queries`)) ? `${work}/queries` : `${dir}/queries`;
    if (!(await exists(src))) return;

    const dst = `${QUERIES}/${spec.name}`;
    await Deno.mkdir(dst, { recursive: true });

    // Custom query overrides for specific languages
    if (spec.name === "kdl") {
        const kdlHighlights = `; Types in parenthesis like (type)
(type) @type

; Builtin types like (annotation_type)
(annotation_type) @type.builtin

; Properties (like key=value, key is the prop)
(prop (identifier) @property)

; Variables (other loose identifiers)
((identifier) @variable)

; Nodes (the first word on a line like 'parser', 'repo') - overrides generic identifiers
(node (identifier) @function)

; Operators
[
 "="
 "+"
 "-"
] @operator

; Literals
(string) @string
(escape) @string.escape
(number) @number
(number (decimal) @number.float)
(number (exponent) @number.float)
(boolean) @boolean
"null" @constant.builtin

; Punctuation
["{" "}"] @punctuation.bracket
["(" ")"] @punctuation.bracket
[";"] @punctuation.delimiter

; Comments
[
  (single_line_comment)
  (multi_line_comment)
] @comment @spell

(node (node_comment)) @comment
(node (node_field (node_field_comment))) @comment
(node_children (node_children_comment)) @comment
`;
        await Deno.writeTextFile(`${dst}/highlights.scm`, kdlHighlights);
    }

    for await (const e of Deno.readDir(src)) {
        if (!e.isFile || !e.name.endsWith(".scm")) continue;
        
        // Skip writing highlights if we provided a custom override above
        if (spec.name === "kdl" && e.name === "highlights.scm") continue;

        let content = await Deno.readTextFile(`${src}/${e.name}`);
        content = content
            .replace(/\s*\(#is-not\?\s+[^)]+\)/g, "")
            .replace(/\s*\(#is\?\s+[^)]+\)/g, "")
            .replace(/\n{3,}/g, "\n\n");

        // SQL upstream queries use Lua patterns (%d, %s, etc.) inside #match?
        // which Neovim's vim regex can't parse. Swap to #lua-match?.
        if (spec.name === "sql") {
            content = content.replace(/#match\?/g, "#lua-match?");
        }
        // Prepend inherits modeline if needed and not already present
        const inherits = QUERY_INHERITS[spec.name]?.[e.name];
        if (inherits && !content.includes("; inherits:")) {
            content = `; inherits: ${inherits}\n\n${content}`;
        }
        await Deno.writeTextFile(`${dst}/${e.name}`, content);
    }
}

// ── inheritance resolution ───────────────────────────────────────────────────

async function resolveInheritsFor(
    lang: string,
    fileName: string,
    visited: Set<string> = new Set(),
): Promise<string | null> {
    if (visited.has(lang)) return null;
    visited.add(lang);

    const filePath = `${QUERIES}/${lang}/${fileName}`;
    if (!(await exists(filePath))) return null;

    let content = await Deno.readTextFile(filePath);
    const match = content.match(/^;\s*inherits:\s*(\S+)/m);
    if (!match) return content;

    const parentName = match[1].replace(/,.*$/, "").trim();
    const resolved = INHERIT_MAP[parentName] || parentName;
    const parentContent = await resolveInheritsFor(resolved, fileName, visited);

    content = content.replace(/^;\s*inherits:.*\n?/m, "");

    if (parentContent) {
        return parentContent + "\n" + content;
    }
    return content;
}

async function resolveAllInherits() {
    for await (const dirEntry of Deno.readDir(QUERIES)) {
        if (!dirEntry.isDirectory) continue;
        const langDir = `${QUERIES}/${dirEntry.name}`;
        for await (const fileEntry of Deno.readDir(langDir)) {
            if (!fileEntry.isFile || !fileEntry.name.endsWith(".scm")) continue;
            const merged = await resolveInheritsFor(dirEntry.name, fileEntry.name);
            if (merged) {
                await Deno.writeTextFile(`${langDir}/${fileEntry.name}`, merged);
            }
        }
    }
}

// ── progress display ─────────────────────────────────────────────────────────

let lines = 0;
let renderTimer: ReturnType<typeof setInterval> | undefined;
const SPIN = "⠋⠙⠹⠸⠼⠴⠦⠧⠇⠏";
let frame = 0;
const cols = () => { try { return Deno.consoleSize().columns; } catch { return 80; } };

function draw() {
    if (lines === 0) return;
    // Move cursor up to start of our block; clear from there down
    Deno.stdout.writeSync(encoder.encode(`\x1b[${lines}A\x1b[J`));
    const w = cols();

    for (const [name, s] of tracker) {
        const c = s.ok === undefined ? SPIN[frame % SPIN.length]
            : s.ok ? "\x1b[32m✓\x1b[0m" : "\x1b[31m✗\x1b[0m";
        const label = `${c} ${name}`;
        const status = s.ok !== undefined ? s.status : `\x1b[90m${s.status}\x1b[0m`;
        const bar = `${label}  ${status}`.padEnd(w);
        Deno.stdout.writeSync(encoder.encode(bar.slice(0, w) + "\n"));
    }
    frame++;
}

function startDrawing(count: number) {
    // Print empty lines to reserve space, then start render loop
    for (let i = 0; i < count; i++) {
        Deno.stdout.writeSync(encoder.encode("\n"));
    }
    lines = count;
    draw();
    renderTimer = setInterval(draw, 100);
}

function stopDrawing() {
    if (renderTimer) { clearInterval(renderTimer); renderTimer = undefined; }
    draw();
    console.log("");
    lines = 0;
}

// ── worker ───────────────────────────────────────────────────────────────────

async function buildOne(spec: ParserSpec) {
    const dir = `${REPOS}/${spec.name}`;
    try {
        tracker.get(spec.name)!.status = "cloning";
        await checkout(spec, dir);

        tracker.get(spec.name)!.status = "generating";
        await compile(spec, dir);

        tracker.get(spec.name)!.status = "queries";
        await installQueries(spec, dir);

        tracker.get(spec.name)!.ok = true;
        tracker.get(spec.name)!.status = "done";
    } catch (e) {
        tracker.get(spec.name)!.ok = false;
        tracker.get(spec.name)!.status = e instanceof Error ? e.message.split("\n")[0] : String(e);
    }
}

// ── main ─────────────────────────────────────────────────────────────────────

async function main() {
    await Deno.mkdir(REPOS, { recursive: true });
    await Deno.mkdir(PARSERS, { recursive: true });
    await Deno.mkdir(QUERIES, { recursive: true });

    const specs = await readConfig();

    for (const s of specs) tracker.set(s.name, { status: "queued" });
    startDrawing(specs.length);

    await Array.fromAsync(pooledMap(CONCURRENCY, specs, buildOne));

    stopDrawing();

    await resolveAllInherits();
}

await main();
