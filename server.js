import express from "express";
import path from "path";
import { fileURLToPath } from "url";

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

const app = express();
const PORT = process.env.PORT || 3000;

// встроенные парсеры вместо body-parser
app.use(express.urlencoded({ extended: true }));
app.use(express.json());

// статика
app.use(express.static(path.join(__dirname, "public")));

// корневой индекс (x-default)
app.get("/", (req, res) => {
  res.sendFile(path.join(__dirname, "public", "index.html"));
});

// пример POST
app.post("/contact", (req, res) => {
  const { name, email, service, message } = req.body || {};
  console.log("📩 New request:", { name, email, service, message });
  res.send(`<h2>Շնորհակալություն, ${name || "գործընկեր"}!</h2><p>Մենք շուտով կկապվենք ${email || "—"}-ի միջոցով։</p>`);
});

// 404
app.use((req, res) => res.status(404).send("Not found"));

app.listen(PORT, () => console.log(`🌐 Server running on port ${PORT}`));
