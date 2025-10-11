import express from "express";
import bodyParser from "body-parser";
import path from "path";
import { fileURLToPath } from "url";

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

const app = express();
const PORT = process.env.PORT || 3000;

app.use(bodyParser.urlencoded({ extended: true }));
app.use(express.static(path.join(__dirname, "public")));

app.get("/", (req, res) => {
  res.sendFile(path.join(__dirname, "public", "index.html"));
});

app.post("/contact", (req, res) => {
  const { name, email, service, message } = req.body;
  console.log("📩 New request:", { name, email, service, message });
  res.send(`<h2>Շնորհակալություն, ${name}!</h2><p>Մենք շուտով կկապվենք ${email}-ի միջոցով։</p>`);
});

app.listen(PORT, () => console.log(`🌐 Server running on port ${PORT}`));
