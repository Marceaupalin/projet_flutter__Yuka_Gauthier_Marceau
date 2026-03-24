migrate((db) => {
  const dao = new Dao(db);

  // 1. History Collection
  const historyCollection = new Collection({
    id: "history_collection_id",
    name: "history",
    type: "base",
    system: false,
    schema: [
      { name: "user", type: "relation", required: true, options: { maxSelect: 1, collectionId: "_pb_users_auth_" } },
      { name: "barcode", type: "text", required: true },
      { name: "name", type: "text" },
      { name: "brand", type: "text" },
      { name: "image_url", type: "url" },
      { name: "nutri_score", type: "text" },
    ],
    listRule: "@request.auth.id = user.id",
    viewRule: "@request.auth.id = user.id",
    createRule: "@request.auth.id = user.id",
    updateRule: "@request.auth.id = user.id",
    deleteRule: "@request.auth.id = user.id",
  });
  dao.saveCollection(historyCollection);

  // 2. Favorites Collection
  const favoritesCollection = new Collection({
    id: "favorites_collection_id",
    name: "favorites",
    type: "base",
    system: false,
    schema: [
      { name: "user", type: "relation", required: true, options: { maxSelect: 1, collectionId: "_pb_users_auth_" } },
      { name: "barcode", type: "text", required: true },
      { name: "name", type: "text" },
      { name: "brand", type: "text" },
      { name: "image_url", type: "url" },
      { name: "nutri_score", type: "text" },
    ],
    listRule: "@request.auth.id = user.id",
    viewRule: "@request.auth.id = user.id",
    createRule: "@request.auth.id = user.id",
    updateRule: "@request.auth.id = user.id",
    deleteRule: "@request.auth.id = user.id",
  });
  dao.saveCollection(favoritesCollection);

  // 3. Recalls Collection
  const recallsCollection = new Collection({
    id: "recalls_collection_id",
    name: "recalls",
    type: "base",
    system: false,
    schema: [
      { name: "barcode", type: "text", required: true },
      { name: "liens_vers_les_images", type: "url" },
      { name: "date_de_publication", type: "text" },
      { name: "nom_de_marque_du_produit", type: "text" },
      { name: "zone_geographique_de_vente", type: "text" },
      { name: "motif_du_rappel", type: "text" },
      { name: "risques_encourus_par_le_consommateur", type: "text" },
      { name: "lien_vers_la_fiche_rappel", type: "url" },
      { name: "date_debut_fin_de_commercialisation", type: "text" },
    ],
    listRule: "",
    viewRule: "",
    createRule: null, 
    updateRule: null,
    deleteRule: null,
  });
  dao.saveCollection(recallsCollection);

}, (db) => {
  const dao = new Dao(db);
  try { dao.deleteCollection(dao.findCollectionByNameOrId("history")); } catch (_) {}
  try { dao.deleteCollection(dao.findCollectionByNameOrId("favorites")); } catch (_) {}
  try { dao.deleteCollection(dao.findCollectionByNameOrId("recalls")); } catch (_) {}
});
