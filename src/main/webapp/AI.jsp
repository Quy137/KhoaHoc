<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Chat AI</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
  <script src="https://cdnjs.cloudflare.com/ajax/libs/showdown/2.1.0/showdown.min.js" integrity="sha512-LhccdVNGe2QMEfI3x4DVV3ckMRe36TfydKss6mJpdHjNFiV07dFpS2xzeZedptKZrwxfICJpez09iNioiSZ3hA==" crossorigin="anonymous" referrerpolicy="no-referrer"></script>
</head>
<body class="d-flex justify-content-center align-items-center vh-100">
  <div class="container">
    <div class="row justify-content-center">
      <div class="col-md-6">
        <div id="chat-container">
          <div id="chat-output"></div>
          <div class="input-group mt-3">
            <input type="text" id="user-input" class="form-control" placeholder="Type your message..." onkeydown="if(event.key==='Enter'){sendMessage()}">
            <button class="btn btn-primary" type="button" onclick="sendMessage()">Send</button>
          </div>
        </div>
      </div>
    </div>
  </div>

  <script>
    var converter = new showdown.Converter();
    var chatOutput = document.getElementById('chat-output');
    var userInput = document.getElementById('user-input');

    function sendMessage() {
      var message = userInput.value.trim();
      if (message === '') return;

      fetch(`https://dailythuonghien.com/api/ai/?message=${encodeURIComponent(message)}`)
        .then(response => {
          if (!response.ok) {
            throw new Error('Network response was not ok');
          }
          return response.text();
        })
        .then(data => { 
          chatOutput.innerHTML = `
            <div class="card mt-3">
              <div class="card-body">
                ${converter.makeHtml(data)}
              </div>
              <div class="card-footer">
                <button class="btn btn-primary btn-sm" onclick="copyToClipboard()">Copy Result</button>
              </div>
            </div>`;
        })
        .catch(error => {
          console.error('There was a problem with the fetch operation:', error);
          chatOutput.innerHTML = `<p>Error: ${error.message}</p>`;
        });

      userInput.value = '';
    }

    function copyToClipboard() {
      var resultText = document.querySelector('.card-body').innerText;
      navigator.clipboard.writeText(resultText)
        .then(() => { 
          alert('Result copied to clipboard!');
        })
        .catch(err => {
          console.error('Failed to copy result: ', err);
        });
    }
  </script>
</body>
</html>
