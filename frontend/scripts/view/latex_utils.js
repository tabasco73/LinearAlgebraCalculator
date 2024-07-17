
export function renderMathJax() {
    MathJax.typesetPromise().then(() => {
        console.log('MathJax typesetting complete');
    }).catch((err) => {
        console.log('MathJax typesetting failed: ', err);
    });
}

export function renderKaTeX() {
    document.querySelectorAll('.katex-display, .katex-inline').forEach(function(el) {
        katex.render(el.textContent, el, {
            throwOnError: false,
            displayMode: el.classList.contains('katex-display')
        });
    });
}

export function latex_formatting(content) {
    return content.replace(/\[\[(.*?)\]\]/g, (match, matrixContent) => {
        const rows = matrixContent.split('][').map(row => row.trim().split(' ').join(' & '));
        return `\$begin:math:display$ \\\\begin{pmatrix} ${rows.join(' \\\\\\\\ ')} \\\\end{pmatrix} \\$end:math:display$`;
    });
}

export function checkString(inputString) {
    if (inputString.includes("Traceback")) {
        return "Request failed";
    } else {
        return inputString;
    }
}