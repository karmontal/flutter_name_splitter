package com.karam.namesplitter;

import android.os.Bundle;
import com.chaquo.python.PyObject;
import com.chaquo.python.Python;
import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;

public class MainActivity extends FlutterActivity {
    private static final String CHANNEL = "com.karam.name_splitter/channel";

    @Override
    public void configureFlutterEngine(FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);

        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL)
            .setMethodCallHandler((call, result) -> {
                if (call.method.equals("split_names")) {
                    String input = call.argument("text");
                    try {
                        Python py = Python.getInstance();
                        PyObject nameSplitter = py.getModule("name_splitter");
                        PyObject output = nameSplitter.callAttr("split_names", input);
                        result.success(output.toString());
                    } catch (Exception e) {
                        result.error("PYTHON_ERROR", e.getMessage(), null);
                    }
                } else {
                    result.notImplemented();
                }
            });
    }
}