import express from "express";
import path from "path";
import { fileURLToPath } from "url";

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

const app = express();
const PORT = process.env.PORT || 3000;

// built-in parsers
app.use(express.urlencoded({ extended: true }));
app.use(express.json());

// serve static from project public/
const projectRoot = path.join(__dirname, "..", "..", "public");
app.use(express.static(projectRoot));

app.get("/", (req, res) => {
  res.sendFile(path.join(projectRoot, "index.html"));
});

app.use((req, res) => res.status(404).send("Not found"));

app.listen(PORT, "0.0.0.0", () => console.log(`Node static server on :${PORT}`));
