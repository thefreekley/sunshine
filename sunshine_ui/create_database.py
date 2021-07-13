import sqlite3

conn = sqlite3.connect("database_sunshine.db") # или :memory: чтобы сохранить в RAM
cursor = conn.cursor()





cursor.execute( """ CREATE TABLE info (
                  id INT  PRIMARY KEY  NOT NULL, 
                   wand_troggle INT NOT NULL,
                   music_troggle INT NOT NULL,
                   off_troggle INT NOT NULL,
                   screen_troggle INT NOT NULL,
                   paint_troggle INT NOT NULL,
                   sleep_from_h INT NOT NULL,
                   sleep_from_m INT NOT NULL,
                   sleep_to_h INT NOT NULL,
                   sleep_to_m INT NOT NULL,
                   value_light INT NOT NULL,
                   value_laud INT NOT NULL,
                   music_mode INT NOT NULL,
                   light_mode INT NOT NULL,
                   color_1 TEXT  NOT NULL,
                   color_2 TEXT  NOT NULL
                   ) """ )

cursor.execute( """ CREATE TABLE last_data (
                 
                   last_id INT NOT NULL,
                   last_comp TEXT  NOT NULL,
                   last_audio_input INT NOT NULL,
                   last_equalizer INT NOT NULL,
                   last_tie INT NOT NULL
                   ) """ )

cursor.execute("INSERT INTO last_data  VALUES(?,?,?,?,?)", [0,"...",3,1,0])

list_save = [0, 1, 0, 0, 0, 0,0,0,0,0,100,50,1,3,"#c60100","#ff0100"]
cursor.execute("INSERT INTO info  VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)", list_save)

conn.commit()
