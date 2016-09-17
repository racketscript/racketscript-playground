
$(document).ready(function () {
    var racketEditor = CodeMirror.fromTextArea(document.getElementById("racket-edit"), {
        lineNumbers: true,
        viewportMargin: Infinity,
        mode: "scheme",
        theme: "monokai",
        matchBrackets: true
    });
    var javascriptEditor = CodeMirror.fromTextArea(document.getElementById("javascript-edit"), {
        lineNumbers: true,
        viewportMargin: Infinity,
        mode: "javascript",
        theme: "monokai",
        matchBrackets: true
    });

    var isCompiling = false;

    $("#compile-btn").click(function() {
        if (isCompiling) {
            return false;
        }
        isCompiling = true;
        setTimeout(function() {
            isCompiling = false;
        }, 3000);

        javascriptEditor.setValue("Compiling ....");
        $.post("/compile", { code: racketEditor.getValue() }, function(data) {
            isCompiling = false;
            javascriptEditor.setValue(data);
        })
    })
});