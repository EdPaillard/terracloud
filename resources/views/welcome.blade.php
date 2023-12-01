<html>
    <head>
    <script
        src="https://code.jquery.com/jquery-3.7.0.min.js"
        integrity="sha256-2Pmvv0kuTBOenSvLm6bvfBSSHrUJ+3A7x6P5Ebd07/g="
        crossorigin="anonymous"></script>
    </head>
    <body>
        <h1>Hello world sample app</h1>
        <p>Counter :<p id="value">{{ $value }}</p></p>
        <button id="add">+1</button>

        <script>
            $(document).ready(function(){
                $("#add").click(function(e){
                    $.get("/api/counter/add", function(data){
                        $('#value').text(data.value);
                    });
                });
            });
        </script>
    </body>
</html>
