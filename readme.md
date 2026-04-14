# PhantomWaves

## Description
PhantomWaves is a web development project built with HTML, CSS, and JavaScript.

## Installation

```bash
git clone <repository-url>
cd phantomwaves
```

## Commands

Back-End
```bash
npm init -y
npm install express cors
```

Front-End
```bash
npm install
```

### Development
```bash
npm install      # Install dependencies
npm start        # Start development server
npm run dev      # Run development mode
```

### Build
```bash
npm run build    # Build for production
npm run minify   # Minify assets
```

### Testing
```bash
npm test         # Run tests
npm run lint     # Lint code
```

### Cleanup
```bash
npm run clean    # Remove build artifacts
```

## Project Structure
```
phantomwaves/
├── index.html
├── css/
├── js/
└── assets/
```

## Usage
Open `index.html` in your browser to view the project.

## License
MIT

## Author
[Your Name]

## MongoDB
1. Installation des dépendances

Dans votre dossier server/, installez Mongoose :

```bash
cd server
npm install mongoose
```

2. Configuration de la connexion

Modifiez votre fichier server/index.js pour inclure la connexion à la base de données.

    [!TIP]
    Si vous n'avez pas MongoDB installé localement, je vous conseille d'utiliser MongoDB Atlas (le cloud gratuit) pour obtenir une URL de connexion (SRV).

```Bash
JavaScript
const express = require('express');
const mongoose = require('mongoose');
const cors = require('cors');

const app = express();
app.use(cors());
app.use(express.json());

// Connexion à MongoDB (Remplacez l'URL par la vôtre si vous utilisez Atlas)
mongoose.connect('mongodb://127.0.0.1:27017/ma_base_de_donnees')
  .then(() => console.log("Connecté à MongoDB !"))
  .catch(err => console.error("Erreur de connexion :", err));

// Définition d'un Modèle (Exemple: Item)
const Item = mongoose.model('Item', { name: String });

// Route pour récupérer les données de la DB
app.get('/api/items', async (req, res) => {
  const items = await Item.find();
  res.json(items);
});

// Route pour ajouter une donnée
app.post('/api/items', async (req, res) => {
  const newItem = new Item({ name: req.body.name });
  await newItem.save();
  res.json(newItem);
});

app.listen(3000, () => console.log('Serveur sur le port 3000'));
```

3. Architecture recommandée

Pour garder un code propre (surtout si votre projet grandit), il est préférable de séparer les responsabilités. Voici le schéma classique d'une application Express avec MongoDB :

    Models/ : Définit la structure de vos données (Schémas Mongoose).

    Routes/ : Définit les points d'entrée de votre API.

    Controllers/ : Contient la logique métier (ce qui se passe quand on appelle une route).

4. Test dans Vue.js

```bash
// Dans un composant Vue
const addItem = async (name) => {
  await fetch('/api/items', {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({ name: name })
  });
  // Rafraîchir la liste après l'ajout...
};
```

4. Fonctionality
- Login
- Log out and page restriction
- webplayer on the navbar