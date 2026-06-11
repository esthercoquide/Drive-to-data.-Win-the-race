import matplotlib.pyplot as plt
import numpy as np

# 1. Données
metrics = [
    "Total Points",
    "Races",
    "Wins",
    "Podiums",
    "Poles",
    "Consistency",
    "DNFs"
]

sergio_data = [1.585, 283, 6,  39,  3, 66, 15]
bottas_data = [1.788, 247, 10, 67, 20, 72, 12]

# 2. Configuration du style
plt.style.use('dark_background')

# APPLICATION DU FOND : #111c34
fig, axes = plt.subplots(nrows=len(metrics), ncols=1, figsize=(8.5, 7.0), facecolor='#111c34')
fig.subplots_adjust(hspace=0.65, left=0.18, right=0.82, top=0.92, bottom=0.05)

# 3. Boucle pour tracer chaque métrique
for i, ax in enumerate(axes):
    ax.set_facecolor('#111c34') # Application du fond sur chaque sous-graphique

    # Calcul des proportions
    total = sergio_data[i] + bottas_data[i]
    if total > 0:
        pct_sergio = (sergio_data[i] / total) * 100
        pct_bottas = (bottas_data[i] / total) * 100
    else:
        pct_sergio, pct_bottas = 50, 50

    # APPLICATION DE LA COULEUR : #2596be (sauf pour la première ligne en violet)
    color_sergio = '#a855f7' if i == 0 else '#2596be'
    color_bottas = '#ffffff'

    # Fond de la jauge vide
    ax.barh([0], [-100], color='#1e2d4a', height=0.35, edgecolor='none')
    ax.barh([0], [100], color='#1e2d4a', height=0.35, edgecolor='none')

    # Tracé des jauges colorées
    ax.barh([0], [-pct_sergio], color=color_sergio, height=0.35, edgecolor='none')
    ax.barh([0], [pct_bottas], color=color_bottas, height=0.35, edgecolor='none')

    # Formatage des textes
    if metrics[i] in ["Consistency", "DNFs"]:
        txt_sergio = f"{sergio_data[i]}%"
        txt_bottas = f"{bottas_data[i]}%"
    else:
        txt_sergio = f"{sergio_data[i]}"
        txt_bottas = f"{bottas_data[i]}"

    # Titres des métriques
    bbox = ax.get_position()
    title_y = bbox.y1 + 0.005
    fig.text(0.5, title_y, metrics[i],
             color='#94a3b8' if i > 0 else '#a855f7',
             fontsize=12, ha='center', va='bottom', weight='bold')

    # Chiffres sur les côtés
    ax.text(-108, 0, txt_sergio, color=color_sergio, fontsize=16, ha='right', va='center', weight='bold')
    ax.text(108, 0, txt_bottas, color='white', fontsize=16, ha='left', va='center', weight='bold')

    ax.set_xlim(-150, 150)
    ax.set_ylim(-0.5, 0.5)
    ax.axis('off')

# Ligne de séparation centrale (adaptée à la couleur du fond pour masquer la jointure)
for ax in axes:
    ax.plot([0, 0], [-0.175, 0.175], color='#111c34', linewidth=2, zorder=3)

plt.show()
