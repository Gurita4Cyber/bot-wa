import fs from 'fs';

async function buildMap() {
    try {
        console.log('Fetching provinces...');
        const provRes = await fetch('https://equran.id/api/v2/imsakiyah/provinsi').then(r => r.json());
        if (provRes.code !== 200 || !provRes.data) {
            throw new Error('Failed to fetch provinces');
        }

        const map = {};

        for (const prov of provRes.data) {
            console.log(`Fetching cities for province: ${prov}...`);
            const cityRes = await fetch('https://equran.id/api/v2/imsakiyah/kabkota', {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({ provinsi: prov })
            }).then(r => r.json());

            if (cityRes.code === 200 && cityRes.data) {
                for (const city of cityRes.data) {
                    // Normalize name for clean lookup, e.g. "kota jakarta" -> "jakarta"
                    const clean = city.toLowerCase()
                        .replace(/^kota\s+/, '')
                        .replace(/^kab\.\s+/, '')
                        .replace(/^kabupaten\s+/, '')
                        .replace(/[^a-z0-9]/g, '');
                    
                    map[clean] = {
                        provinsi: prov,
                        kabkota: city
                    };
                }
            }
            // Add a tiny delay to avoid spamming the API
            await new Promise(resolve => setTimeout(resolve, 100));
        }

        fs.writeFileSync('lib/imsakiyah_map.json', JSON.stringify(map, null, 2));
        console.log('Successfully saved lib/imsakiyah_map.json!');
    } catch (error) {
        console.error('Error building imsakiyah map:', error);
    }
}

buildMap();
