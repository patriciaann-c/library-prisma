import { client } from "./prisma-client.js";

const newBook = await client.books.create({
    data: {
        title: "Rich dad poor dad",
        publication_date: new Date('2000-04-01'),
        price: 14.99,

        // tabella collegata
        authors: {
            create: {
                name: "Robert Kiyosaki"
            }
        }
    }
});

// Chiude il pool di connessioni aperto dall'adapter.
await client.$disconnect();