
$(document).ready(function () {
    /* Create editors */
    var racketEditor = CodeMirror.fromTextArea(
	document.getElementById("racket-edit"), {
            lineNumbers: true,
            mode: "scheme",
            theme: "neat",
            matchBrackets: true,
	});

    var consoleLogEditor = CodeMirror.fromTextArea(
	document.getElementById("console-log-edit"), {
            lineNumbers: false,
	    readOnly: true,
            mode: "text",
            theme: "neat",
            matchBrackets: true,
	});

    var jsOutEditor = CodeMirror.fromTextArea(
	document.getElementById("jsout-edit"), {
            lineNumbers: true,
	    readOnly: false,
            mode: "javascript",
            theme: "neat",
            matchBrackets: true,
	});

    var isCompiling = false;

    function overrideConsole(frame) {
	var win = frame.contentWindow;
	var newLog = function(level) {
	    return function () {
		var args = Array.prototype.slice.call(arguments);
		consoleLogEditor.replaceRange("[" + level + "] ", {line: Infinity});
		args.forEach(function (v) {
		    var s;
		    if (typeof v === 'string') {
			s = v;
		    } else if (typeof v === 'number') {
			s = v.toString()
		    } else {
			s = JSON.stringify(v);
		    }
		    consoleLogEditor.replaceRange(s + " ", {line: Infinity});
		});
		consoleLogEditor.replaceRange("\n", {line: Infinity});
	    }
	}
	
	var c = Object.create({
	    log: newLog("log"),
	    debug: newLog("debug"),
	    error: newLog("error"),
	    info: newLog("info")
	});

	c.prototype = win.console;
	win.console = c;
	win.document.console = c;
    }

    function runRacket(code) {
	var ifrm = document.getElementById("run-area");
	var src = ifrm.src;
	ifrm.src = "";
	ifrm.src = src;
	ifrm.onload = function () {
	    var doc = ifrm.contentWindow.document;
	    var head = doc.getElementsByTagName('head')[0];
	    var script = doc.createElement('script');
	    overrideConsole(ifrm);
	    script.type = "module";
	    script.text = code;
	    head.appendChild(script);
	    ifrm.contentWindow.System.loadScriptTypeModule();
	}
    }

    function run() {
	var code = jsOutEditor.getValue();
	if (code === "") {
	    alert("Code not compiled!");
	    return;
	}
	consoleLogEditor.setValue("Console Log:\n");
	runRacket(code);
    }

    function compile(execute) {
	if (isCompiling) {
            return false;
        }
        isCompiling = true;
        setTimeout(function() {
            isCompiling = false;
        }, 3000);

	consoleLogEditor.setValue("Console Log:\n");
        jsOutEditor.setValue("Compiling ....");
        $.post("/compile", { code: racketEditor.getValue() })
            .done(function(data) {
                jsOutEditor.setValue(js_beautify(data));
                if (execute === true) {
                    run();
                }
            })
            .fail(function(xhr, status, err) {
		consoleLogEditor.setValue("Compilation error:\n" +
					  xhr.responseText);
		jsOutEditor.setValue("");
            })
	    .always(function() {
		isCompiling = false;
	    });
    }

    $("#compile-btn").click(compile);
    $("#run-btn").click(run);
    $("#compile-run-btn").click(function() { compile(true); });

    /* Create splits */
    Split(["#left-container", "#right-container"], {
	direction: 'horizontal',
	sizes: [50, 50],
	gutterSize: 2
    });

    Split(["#console-log-container", "#play-container"], {
	direction: 'vertical',
	gutterSize: 2,
	sizes: [25, 75]
    });

    Split(["#racket-container", "#jsout-container"], {
	direction: 'vertical',
	gutterSize: 2,
	sizes: [70, 30]
    });

});
