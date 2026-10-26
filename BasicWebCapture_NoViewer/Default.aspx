<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="BasicWebCapture_NoViewer._Default" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title></title>
    <script src="/WebCapture/jquery-3.5.1.min.js" type="text/javascript"></script>
    <script src="/WebCapture/atalaWebCapture.js" type="text/javascript"></script>

    <script type="text/javascript">
        // Initialize Web Scanning and Web Viewing
        $(function () {
            try {
                Atalasoft.Controls.Capture.WebScanning.initialize({
                    handlerUrl: 'WebCaptureHandler.ashx',
                    onUploadCompleted: function (eventName, eventObj) {
                        if (eventObj.success) {
                            document.getElementById('resultDiv').innerHTML = "Status: Upload Success... " + eventObj.documentFilename;
                        }
                    },
                    onScanError: scanErrorHandler,
                    scanningOptions: { applyVRS: false, pixelType: 0, showScannerUI: false }
                });
            } catch (error) {
                alert('Thrown error: ' + error.description);
                Atalasoft.Controls.Capture.WebScanning.dispose();
            }
        });


        function scanErrorHandler(msg, params) {
            switch (msg) {
                case Atalasoft.Controls.Capture.Errors.badBrowser:
                    alert(msg);
                    break;
                case Atalasoft.Controls.Capture.Errors.activeX:
                    alert(
		            "The ActiveX Scanning Control needs to be installed, updated or enabled.\n" +
		            "When prompted, please allow the WingScan Web Scanning Control to install itself,\n" +
		            "or Manage Add-ons through IE Settings. Refresh your browser when completed.");
                    break;
                case Atalasoft.Controls.Capture.Errors.noTwain:
                    alert(
                "TWAIN is not installed on this computer.\n" +
                "Contact your system administrator.");
                    break;
                case Atalasoft.Controls.Capture.Errors.noPlugin:
                    var pluginUrl = window.location.protocol + "//" + window.location.host + "/WebCapture/" + params.filename
                    alert(
	                "The WingScan Web Scanning plugin is not available. \n\n" +
	                "Please download from : " + pluginUrl + "\n" +
	                "If you are not prompted to install, the plugin may be installed but disabled. \n" +
	                "enable it through Tools... Extensions. \n" +
	                "Refresh your browser when completed.");
                    window.open(pluginUrl, '_downloadPlugin');
                    break;
                case Atalasoft.Controls.Capture.Errors.oldPlugin:
                    var pluginUrl = window.location.protocol + "//" + window.location.host + "/WebCapture/" + params.filename
                    alert(
	                "The WingScan Web Scanning plugin is out of date.<br />" +
	                "To download and install the latest version from " +
	                params.filename);
                    window.open(pluginUrl, '_downloadPlugin');
                    break;
                case "VRS: No license or license expired":
                    alert("Scanning aborted with a VRS licensing exception. \n\n" +
	                "VRS is enabled, but no VRS license is present.\n" +
	                "Either turn VRS off in your scanningOptions or \n" +
	                "activate a license with VRS.");
                    break;
                default:
                    alert(msg);
                    break;
            }
        }


        function scanWithSelectedScanner() {
            Atalasoft.Controls.Capture.WebScanning.scanningOptions.scanner = $('.atala-scanner-list').val();
            Atalasoft.Controls.Capture.WebScanning.scan();
        }

        // You can use this approach if you want to completey change scanning options
//        function scanWithSettings() {
//            var scanningOptions = { pixelType: 0, showScannerUI: false, allpyVRS: false, scanner: $('.atala-scanner-list').val() };
//            Atalasoft.Controls.Capture.WebScanning.scanningOptions = scanningOptions;
////            console.log("scanningOptions: ");
////            console.log(Atalasoft.Controls.Capture.WebScanning.scanningOptions);
//            Atalasoft.Controls.Capture.WebScanning.scan();
//        }

    </script>
</head>
<body>
    <form id="form1" runat="server">
    <div id="scanDiv">
        <h1>Basic WingScan Web Capture Demo</h1>
        <h3>Using WingScan and NO Viewer</h3>
        <p>Select your scanner and click the scan button... the file will be uploaded to /atala-capture-upload/ with a unique filename (the filename will appear in the status below)</p>
        <p>&nbsp;</p>
        <p>Select Scanner:
            <select class="atala-scanner-list" disabled="disabled" name="scannerList" style="width:22em">
                <option selected="selected">(no scanners available)</option>
            </select>
            &nbsp;
            <input type="button" id="scanNOW" value="Scan" onclick="scanWithSelectedScanner(); return false;" />
        </p>

    </div>
    <div id="resultDiv">Status: NoUploads</div>
    </form>
</body>
</html>
