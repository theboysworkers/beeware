-- Create user and database
CREATE USER IF NOT EXISTS 'helpuser'@'%' IDENTIFIED BY 'helpuser';
GRANT ALL PRIVILEGES ON helpdesk.* TO 'helpuser'@'%' WITH GRANT OPTION;
FLUSH PRIVILEGES;

DROP DATABASE IF EXISTS helpdesk;
CREATE DATABASE helpdesk;
USE helpdesk;

-- Tables
CREATE TABLE IF NOT EXISTS ticket (
    id CHAR(10) PRIMARY KEY,
    nome VARCHAR(100),
    email VARCHAR(100),
    messaggio TEXT,
    stato ENUM('Aperto','Chiuso') DEFAULT 'Aperto',
    data_apertura TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    data_chiusura TIMESTAMP NULL DEFAULT NULL
);

CREATE TABLE IF NOT EXISTS users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    ruolo ENUM('admin','user') DEFAULT 'user',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Admin user (password: admin123)
INSERT INTO users (username, password, ruolo) VALUES 
('admin', '$2y$10$5GlfHk5E9qds9xR9r.ZkkuCqXm.Zjk1qwHDCLXJdcu9/yqGAItmyy', 'admin');

-- Procedure to generate dynamic tickets with random email domain
DELIMITER $$

CREATE PROCEDURE populate_tickets(IN num INT)
BEGIN
    DECLARE i INT DEFAULT 0;
    DECLARE first_name VARCHAR(50);
    DECLARE last_name VARCHAR(50);
    DECLARE status_val ENUM('Aperto','Chiuso','In Attesa');
    DECLARE apertura TIMESTAMP;
    DECLARE chiusura TIMESTAMP;
    DECLARE messaggio TEXT;
    DECLARE domain VARCHAR(100);

    WHILE i < num DO

        SET @ticket_id = LEFT(MD5(RAND()), 10);  -- 10 caratteri casuali

        -- 100 first names
        SET first_name = ELT(FLOOR(1 + RAND()*100),
            'Mario','Giulia','Luca','Sofia','Alessandro','Marisa','Davide','Milena',
            'Mirko','Patrizio','Giulio','Tommaso','Lorenzo','Marlena','Fabio','Luisa',
            'Andrea','Rachele','Rebecca','Giorgia','Martina','Luigi','Silvia','Francesca',
            'Nicola','Stefano','Alessia','Carlo','Valentina','Federico','Alberto','Filippo',
            'Mariza','Giuseppe','Paola','Michele','Assunta','Orazio',
            'Elena','Simone','Claudia','Giorgio','Francesco','Sara','Chiara','Antonio',
            'Martina','Giovanni','Sabrina','Cristina','Emanuele','Valerio','Cecilia',
            'Domenico','Alessandro','Giulia','Lorenzo','Matteo','Giovanna','Rita',
            'Silvano','Nadia','Pietro','Gilda','Rocco','Tiziana','Gilda','Alessia',
            'Vittoria','Giorgio','Michela','Sergio','Lucia','Alfredo','Giovanna','Nicoleta',
            'Alessio','Beatrice','Carolina','Dario','Elettra','Fabrizio','Ginevra','Ilaria',
            'Jacopo','Katia','Leonardo','Marta','Nicolò','Oriana','Pia','Quinto',
            'Roberta','Samuele','Tania','Umberto','Vera','Zoe','Alma','Benedetta'
        );

        -- 100 last names
        SET last_name = ELT(FLOOR(1 + RAND()*100),
            'Murti','Bianchi','Verdi','Neri','Gallo','Buzzi','Filli','Martini',
            'Geradi','Marigli','Bolli','Fizzi','Orlandi','Rossi','Ferrari','Esposito',
            'Romano','Conti','Ricci','Marino','Greco','Bruno','De Luca','Fontana',
            'Galli','Moretti','Barbieri','Rizzo','Longo','Pellegrini',
            'Alfieri','Amato','Baldini','Barone','Bertolini','Cappelli','Carbone',
            'Cattaneo','Cipriani','Colombo','D’Angelo','De Santis','Di Marco',
            'Fabbri','Fiorentino','Giordano','Giuliani','Giorgetti','Lombardi',
            'Mancini','Marchetti','Martelli','Mazzoni','Montanari','Morelli',
            'Pavone','Pietro','Rinaldi','Sartori','Sorrentino','Toscano',
            'Valente','Ventura','Vitale','Zanetti','Zanoni','Zocchi',
            'Cavalli','Della Valle','Fioravanti','Gatti','Lazzari','Montalto',
            'Pugliese','Ruggeri','Sgambati','Tarantino','Vitali','Zamboni'
        );

        -- Status with (95% chiuso, 5% aperto)
        SET status_val = IF(RAND() < 0.95, 'Chiuso', 'Aperto');


        -- If the status is 'Aperto' assing recent date (last 5 days), if status is 'Chiuso' last 90 days considering 8:00-20:00
        SET apertura = IF(
            status_val='Aperto',
            TIMESTAMP(
                CURRENT_DATE - INTERVAL FLOOR(RAND()*5) DAY,
                MAKETIME(8 + FLOOR(RAND()*12), FLOOR(RAND()*60), FLOOR(RAND()*60))
            ),
            TIMESTAMP(
                CURRENT_DATE - INTERVAL FLOOR(RAND()*90) DAY,
                MAKETIME(8 + FLOOR(RAND()*12), FLOOR(RAND()*60), FLOOR(RAND()*60))
            )
        );

        -- If the status is 'Chiuso', assign a closing date that is 1 to 10 days after the opening date
        SET chiusura = IF(
            status_val='Chiuso',
            TIMESTAMP(
                DATE(apertura) + INTERVAL (1 + FLOOR(RAND()*10)) DAY,
                MAKETIME(8 + FLOOR(RAND()*12), FLOOR(RAND()*60), FLOOR(RAND()*60))
            ),
            NULL
        );

        -- Choose a random email domain (6 domains)
        SET domain = ELT(FLOOR(1 + RAND()*6),
            '@theboys.it','@gmail.com','@virgilio.it','@outlook.com','@yahoo.com','@aruba.it');

        -- Choose a random message
        SET messaggio = ELT(FLOOR(1 + RAND()*50),
            'Rilevato arresto anomalo dell`applicazione immediatamente dopo l`avvio in seguito all`ultimo aggiornamento rilasciato. Il processo si interrompe senza generare log esplicativi.',
            'Segnalato errore di autenticazione persistente: il sistema rifiuta l`accesso anche in presenza di credenziali verificate e correttamente formattate.',
            'Interfaccia web non funzionante: la schermata principale resta bloccata in fase di caricamento mentre la console mostra errori JavaScript relativi a librerie non inizializzate.',
            'Sistema in timeout prolungato oltre il limite previsto durante la fase di caricamento delle risorse; al termine viene restituito errore 504 da parte del server.',
            'Rilevata assenza di alcune funzionalità dopo l`aggiornamento dell`applicativo: il pulsante `Salva` non viene più visualizzato nella sezione impostazioni.',
            'Notifiche push non recapitabili sui dispositivi Android nonostante corretta configurazione del servizio; il problema non si verifica su dispositivi iOS.',
            'Disallineamento dati tra versione desktop e mobile: le modifiche effettuate su un dispositivo non risultano visibili sugli altri client collegati allo stesso account.',
            'Il client SMTP restituisce costantemente errore di autenticazione durante la fase di invio messaggi nonostante le credenziali siano verificate e funzionanti su altri sistemi.',
            'La dashboard visualizza dati non aggiornati o incongruenti rispetto alle metriche reali; il problema persiste anche dopo aggiornamento manuale della pagina.',
            'La funzione di esportazione non produce correttamente i dati richiesti: il file generato risulta vuoto o con intestazioni senza contenuto.',
            'Rilevati significativi rallentamenti dell`interfaccia utente durante la navigazione tra le sezioni principali dell`applicativo, con tempi di risposta superiori alla norma.',
            'Il motore di rendering grafico non visualizza correttamente alcuni elementi dell`interfaccia su dispositivi con risoluzioni ridotte, causando sovrapposizioni e tagli.',
            'Riscontrato consumo anomalo di memoria da parte del processo principale anche in condizioni di inattività, con rischio di crash improvvisi su dispositivi meno performanti.',
            'Interruzione della connessione al server durante l`esecuzione di richieste API, con conseguente mancata restituzione dei dati richiesti.',
            'La configurazione dell`account utente non viene salvata correttamente dopo la modifica dei parametri: al riavvio dell`applicazione vengono ripristinati i valori precedenti.',
            'Il sistema di invio notifiche e-mail non risulta operativo dopo l`aggiornamento delle impostazioni: nessun messaggio viene recapitato nonostante lo stato risulti attivo.',
            'Rilevati errori ricorrenti nei log del servizio di background relativi a operazioni pianificate che non vengono completate.',
            'Durante la fase di validazione dei dati in input vengono generati errori generici non gestiti, impedendo il completamento della procedura.',
            'Alcuni componenti dell`applicazione non vengono inizializzati correttamente all`avvio, causando malfunzionamenti nelle sezioni dipendenti.',
            'I processi schedulati non vengono eseguiti all`orario previsto anche se correttamente configurati all`interno del sistema.',
            'Arresto anomalo dell`applicazione durante la fase di avvio.',
            'Accesso negato nonostante credenziali valide.',
            'Caricamento dell`interfaccia bloccato per assenza di risposta dallo script principale.',
            'Timeout prolungato con restituzione codice 504.',
            'Pulsante `Salva` non presente nell`interfaccia dopo aggiornamento.',
            'Notifiche push non recapitate su dispositivi Android.',
            'Dati non sincronizzati tra client desktop e mobile.',
            'Errore di autenticazione restituito dal client SMTP durante l`invio.',
            'Valori della dashboard non coerenti con le metriche archiviate.',
            'File di esportazione generato senza contenuto.',
            'Rallentamenti significativi nell`esecuzione delle richieste API.',
            'Saturazione della memoria del processo principale in condizioni di inattività.',
            'Connessione al server interrotta durante handshake TLS.',
            'Parametri di configurazione non salvati dopo modifica.',
            'Evento pianificato non eseguito nell`orario previsto.',
            'Procedure batch non completate entro il tempo limite configurato.',
            'Dati temporanei non eliminati correttamente, con crescita anomala della cartella di cache.',
            'Errore di parsing dei dati ricevuti dal servizio esterno, senza generazione di eccezioni gestite.',
            'Modulo di sincronizzazione disabilitato a seguito di malfunzionamento nella fase di inizializzazione.',
            'File di log non aggiornati correttamente, con perdita di tracciamento eventi recenti.',
            'Errore di serializzazione dati durante il trasferimento tra client e server.',
            'Componenti di interfaccia non renderizzati su specifiche risoluzioni video.',
            'Servizio di autenticazione non risponde entro i tempi previsti, con rilascio di codice 503.',
            'Parametri di configurazione rete non applicati correttamente dopo modifica.',
            'Modulo di backup non genera file completi a causa di interruzione inattesa.',
            'Processi concorrenti provocano conflitti di accesso alle risorse condivise.',
            'Cache dati non aggiornata correttamente, generando visualizzazioni obsolete.',
            'Servizio di notifica interna non invia messaggi programmati secondo l`orario configurato.',
            'Errore di lettura/scrittura sul database senza segnalazione di eccezioni esplicite.',
            'Thread di elaborazione rimane in stato bloccato per tempo prolungato.',
            'Connessione HTTPS instabile su reti mobili, con interruzioni frequenti.',
            'Modulo di esportazione dati genera file con intestazioni incomplete.',
            'Evento di aggiornamento schedulato non avviato a causa di conflitto con processi attivi.',
            'Parametri di sicurezza applicati parzialmente, lasciando sezioni non protette.',
            'Processo di importazione dati terminato prematuramente senza registrazione errore dettagliato.'
        );

        -- Insert of values
        INSERT INTO ticket (id,nome,email,messaggio,stato,data_apertura,data_chiusura)
        VALUES (
            @ticket_id,
            CONCAT(first_name,' ',last_name),
            CONCAT(LOWER(first_name),'.',LOWER(last_name), domain),
            messaggio,
            status_val,
            apertura,
            chiusura
        );


        SET i = i + 1;
    END WHILE;
END$$

DELIMITER ;

-- Populate 1000 records
CALL populate_tickets(1000);

