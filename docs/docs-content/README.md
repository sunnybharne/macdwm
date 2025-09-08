# macdwm Documentation

This directory contains the documentation for macdwm, built with MkDocs and Material theme.

## Local Development

### Prerequisites
- Python 3.x
- pip

### Setup
```bash
cd docs
python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt
```

### Serve Locally
```bash
# Using the script
./serve.sh

# Or manually
mkdocs serve
```

The documentation will be available at `http://127.0.0.1:8000`

### Build
```bash
mkdocs build
```

## Deployment

The documentation is automatically deployed to GitHub Pages when changes are pushed to the `main` branch.

### Manual Deployment
```bash
mkdocs gh-deploy
```

## Structure

- `index.md` - Homepage
- `installation.md` - Installation guide
- `user-guide.md` - User manual
- `releases.md` - Release notes
- `troubleshooting.md` - Common issues and solutions
- `mkdocs.yml` - MkDocs configuration
- `requirements.txt` - Python dependencies

## Customization

Edit `mkdocs.yml` to customize:
- Site name and description
- Navigation structure
- Theme settings
- Plugins and extensions