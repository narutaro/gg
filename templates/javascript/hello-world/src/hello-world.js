const args = process.argv.slice(2);
const message = `Hello, I'm a Greengrass node.js component - ${args[0]}!`;

setInterval(() => {
  console.log(message);
}, 5000);
