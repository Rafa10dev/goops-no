import app from "./app.js";

app.listen(process.env.PORT, () => {
  console.log(`GoOps NO API running on port ${process.env.PORT}`);
});
