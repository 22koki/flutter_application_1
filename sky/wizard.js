var canvas = document.getElementById("canvas");
var lastFrame = Date.now();
var thisFrame;

function draw() {
    thisFrame = Date.now();
    time += (thisFrame - lastFrame) / 1000;
    lastFrame = thisFrame;
    gl.uniform1f(timeHandle, time);
    gl.drawArrays(gl.TRIANGLE_STRIP, 0, 4);

    requestAnimationFrame(draw);

}