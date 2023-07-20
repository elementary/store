import esbuild from 'esbuild'
import { sassPlugin } from 'esbuild-sass-plugin'
import copyStaticFiles from 'esbuild-copy-static-files'

const args = process.argv.slice(2)
const watch = args.includes('--watch')
const deploy = args.includes('--deploy')

const loader = {
    // Add loaders for images/fonts/etc, e.g. { '.svg': 'file' }
}

const plugins = [
    sassPlugin(),
    copyStaticFiles({ dest: '../priv/static' }),
]

let opts = {
    entryPoints: ['js/app.js'],
    bundle: true,
    target: 'es2017',
    outdir: '../priv/static/assets',
    logLevel: 'info',
    loader,
    plugins
}

if (watch) {
    opts = {
        ...opts,
        sourcemap: 'inline'
    }
}

if (deploy) {
    opts = {
        ...opts,
        minify: true
    }
}


if (watch) {
    const context = await esbuild.context(opts)
    await context.watch()
} else {
    await esbuild.build(opts)
}