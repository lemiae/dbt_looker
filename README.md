# TheLook E-commerce Analytics - dbt Project

## 📋 Vue d'ensemble

Ce projet dbt transforme les données brutes de TheLook E-commerce en modèles analytiques prêts pour Looker. Il suit une architecture en 3 couches (staging → intermediate → marts).

## 🎯 Objectif de ce projet

Se former en créant un projet avec des outils BI :
- **dbt** pour la transformation de données
- **BigQuery** comme entrepôt de données
- **Looker** pour la visualisation

## 🏗️ Architecture simplifiée

```
models/
├── staging/          # 🧹 Nettoyage des données brutes
│   ├── stg_users.sql         # Clients avec age_group, gender_clean
│   ├── stg_orders.sql        # Commandes avec statuts normalisés  
│   ├── stg_order_items.sql   # Items avec prix nettoyés
│   └── stg_products.sql      # Produits avec calculs de marge
│
├── intermediate/     # 🔄 Agrégations métier
│   ├── int_user_orders.sql   # Métriques par client (RFM)
│   └── int_product_metrics.sql # Performance par produit
│
└── marts/           # 📊 Tables finales pour Looker
    ├── dim_users.sql         # Dimension clients enrichie
    ├── dim_products.sql      # Dimension produits avec KPIs  
    └── fact_sales.sql        # Faits de ventes (cœur analytique)
```

## 🎯 Métriques Business disponibles

### 👥 Analyse Clients
- **Segmentation RFM** : VIP (10+ commandes, 500€+ CA) → One-time
- **Statut de la derniere commande** : Active (≤30j) → Lost (>180j)
- **Panier moyen** et fréquence d'achat

### 🛍️ Performance Produits  
- **Classification automatique** : Star → Underperformer (selon CA/volume)
- **Rentabilité** : Marge brute, profit total par produit
- **Statut d'activité** : Active → Discontinued

### 💰 Métriques Financières
- **CA** par période/segment/canal
- **Profit** et marges par transaction
- **Remises** appliquées vs prix de détail
- **Saisonnalité** des ventes

## 🚀 Déployement (3 commandes)

```bash
# 1. Vérifier la configuration
dbt debug

# 2. Construire tous les modèles  
dbt run

# 3. Tester la qualité des données
dbt test
```

## 🧪 Qualité des données

Tests automatiques inclus :
- **Unicité** des clés primaires 
- **Cohérence** des références (user_id, product_id)
- **Non-nullité** des champs critiques (sale_price, order_date)

## 📚 Documentation auto-générée

```bash
dbt docs generate  # Créer la documentation
dbt docs serve     # Ouvrir dans le navigateur
```

## 💡 Points techniques mis en avant

✅ **Architecture scalable** : staging → intermediate → marts  
✅ **Modularité** : Chaque couche a un rôle précis  
✅ **Performance** : Vues pour staging, tables pour marts  
✅ **Documentation** : Commentaires explicatifs dans chaque modèle  

---

**Technologies** : dbt-core, BigQuery, SQL, Looker
**Dataset** : TheLook E-commerce (BigQuery public data) 


## 📊 Looker Studio 

# Fichier LookML
Comme je n'avais pas accès à Looker, j'ai créer dansle dossier **LookML** chaque fichier que j'aurais pu avoir besoin.
Cela m'a permis de comprendre la syntaxe du LookML.

# Dashboard Looker Studio

**nom**: DBT_Ecommerce_Analyse
**structure** :
    1. Résumé analytique
    2. Analyse des produits et des stocks
    3. Analyse Client et Segmentation
    4. Opérations et Logistique
    5. Analyse Saisonnière et Prévisions
**lien** : https://lookerstudio.google.com/s/go-DJ2ZVvz0


