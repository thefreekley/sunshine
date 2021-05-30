import sqlite3

conn = sqlite3.connect("database_sunshine.db") # или :memory: чтобы сохранить в RAM
cursor = conn.cursor()





cursor.execute( """ CREATE TABLE info (
                  id INT  PRIMARY KEY  NOT NULL, 
                   wand_troggle INT NOT NULL,
                   music_troggle INT NOT NULL,
                   off_troggle INT NOT NULL,
                   sleep_troggle INT NOT NULL,
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


conn.commit()
