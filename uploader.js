// function seasideCallbackFileUploaded(ajaxParameter) {
// 	// Will be redefined dynamically
// }

// function seasideUploadSessionUuid() {
// 	// Will be redefined dynamically	
// }


$(document).ready(function() {

	$("#pluploadStartButton").hide();

	var uploader = new plupload.Uploader({
		browse_button: "pluploadBrowseButton",
		url: ("/lib/webbase/upload_gateway/upload.php?id=" + seasideUploadSessionUuid() ),
		drop_element: 'pluploadDropzone',
		// multipart_params: {
		// 	importMetadata: '1'
		// },
		//	chunk_size: "200kb",
		//	max_retries: 3
	});

	//   filters: {
	//     max_file_size: #{MAX_FILE_SIZE || 0},
	//     prevent_duplicates: true,
	//     mime_types : [
	//       { title : "Media files", extensions : "#{file_extensions}" }
	//     ]
	//   }    
	// });

	
//	uploader.init();

	uploader.bind("FilesAdded", function(up, files) {
		var html = "";
		plupload.each(files, function(file) {
			html += "<li id=\"" + file.id + "\">" + file.name + " (" + plupload.formatSize(file.size) + ") <span class=\"uploadStatus\">0%</span></li>";
		});
		document.getElementById("pluploadFilelist").innerHTML += html;
		$("#pluploadStartButton").show();

	});

	uploader.bind("UploadProgress", function(up, file) {
		document.getElementById(file.id).querySelector("span.uploadStatus").innerHTML = "<span>" + file.percent + "%</span>";
	});

	uploader.bind("FileUploaded", function(up, file, result) {
		if (result.status == 200) {
			var ajaxParameter = result.response + "/" + file.name;
			seasideCallbackFileUploaded(ajaxParameter);
		} else {
			alert("Upload-Fehler!");
		}
	});

	uploader.bind("UploadComplete", function(up, file) {
		// Timeout, damit ajax calls fertig machen können
		setTimeout(function() {
			location.reload();
		}, 1000)
	});

	uploader.bind('PostInit', function(up) {
		if (!up.features.dragdrop) {
			$('#pluploadDropzone').addClass('inactive')
		}
	});
	

	uploader.bind("Error", function(up, err) {
		alert("\nFehler #" + err.code + ": " + err.message);
	});

	document.getElementById("pluploadStartButton").onclick = function() {
		uploader.start();
	};

	uploader.init();


});
