const counter = document.querySelector(".ppl-viewed");
async function updateViewCount() {
    const response = await fetch("https://qy5sqiurefdzq2wrn6laib3w2i0jrxhb.lambda-url.us-east-1.on.aws/");
    const data = await response.json();
    counter.innerHTML = ` You are viewer: ${data} :)`;

}

updateViewCount();


