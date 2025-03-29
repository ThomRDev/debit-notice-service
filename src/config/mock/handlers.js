const { http, HttpResponse } = require("msw");

const generateSevenDigitNumber = () => {
  return Math.floor(1000000 + Math.random() * 9000000);
};
const handlers = [
  http.post("https://sap.com/api/migrar", async ({ request }) => {
    const migrations = await request.json();

    if (!Array.isArray(migrations)) {
      return new HttpResponse(JSON.stringify({ error: "Invalid input, expected an array" }), { status: 400 });
    }

    return HttpResponse.json({
      data: migrations.map((migration) => ({
        numero_aviso: migration,
        numero_sap: generateSevenDigitNumber()
      })),
    });
  }),
];


module.exports = {
  generateSevenDigitNumber,
  handlers
}