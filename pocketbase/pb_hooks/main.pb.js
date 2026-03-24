/// <reference path="../pb_data/types.d.ts" />

// Cron job to fetch recalls every day at 3 AM
cronAdd("fetch_recalls", "0 3 * * *", () => {
    fetchRecallsFromGov();
});

// A route to manually trigger the sync for testing
routerAdd("GET", "/api/sync-recalls", (c) => {
    fetchRecallsFromGov();
    return c.json(200, { message: "Sync started" });
});

function fetchRecallsFromGov() {
    try {
        const url = "https://data.economie.gouv.fr/api/explore/v2.1/catalog/datasets/rappelconso0/records?limit=100";
        const res = $http.send({
            url: url,
            method: "GET",
        });

        if (res.statusCode === 200 && res.json && res.json.results) {
            const records = res.json.results;
            const collection = $app.dao().findCollectionByNameOrId("recalls");

            for (let i = 0; i < records.length; i++) {
                const item = records[i];
                if (!item.code_barres) continue;

                // Check if already exists
                let existing;
                try {
                    existing = $app.dao().findFirstRecordByData("recalls", "barcode", item.code_barres);
                } catch (e) {
                    // Not found
                }

                if (!existing) {
                    const newRecord = new Record(collection);
                    newRecord.set("barcode", item.code_barres);
                    newRecord.set("liens_vers_les_images", item.liens_vers_les_images || "");
                    newRecord.set("date_de_publication", item.date_de_publication || "");
                    newRecord.set("nom_de_marque_du_produit", item.nom_de_marque_du_produit || "");
                    newRecord.set("zone_geographique_de_vente", item.zone_geographique_de_vente || "");
                    newRecord.set("motif_du_rappel", item.motif_du_rappel || "");
                    newRecord.set("risques_encourus_par_le_consommateur", item.risques_encourus_par_le_consommateur || "");
                    newRecord.set("lien_vers_la_fiche_rappel", item.lien_vers_la_fiche_rappel || "");
                    newRecord.set("date_debut_fin_de_commercialisation", item.date_debut_fin_de_commercialisation || "");
                    
                    $app.dao().saveRecord(newRecord);
                }
            }
        }
    } catch (e) {
        $app.logger().error("Error fetching recalls: " + e.message);
    }
}
