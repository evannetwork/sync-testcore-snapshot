const http = require('http');

const options = {
  'method': 'POST',
  'hostname': 'localhost',
  'port': '8545',
  'headers': {
    'Content-Type': 'application/json',
  }
};

setInterval(async() => {
  try {
    const response = JSON.parse(await doRequest());
    if(response.result.currentBlock) {
      console.log(`current sync block ${parseInt(response.result.currentBlock, 16)}`)
    }
    if(response.result.currentBlock && parseInt(response.result.currentBlock, 16) >= process.env.TARGET_BLOCK) {
      process.exit()
    }

    if(response.result === false) {
      process.exit()
    }
  } catch(e) {
    console.dir(e)
    process.exit(1)
  }



}, 10000)


const doRequest = async() => {
  return new Promise((resolve, rej) => {
    var req = http.request(options, function (res) {
      var chunks = [];

      res.on("data", function (chunk) {
        chunks.push(chunk);
      });

      res.on("end", function (chunk) {
        var body = Buffer.concat(chunks);
        resolve(body.toString())
      });

      res.on("error", function (error) {
        console.error(error);
        rej(error)
      });
    });

    var postData = JSON.stringify({"method":"eth_syncing","params":[],"id":1,"jsonrpc":"2.0"});

    req.write(postData);

    req.end();
  });
}

