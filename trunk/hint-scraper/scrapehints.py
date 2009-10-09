#!/usr/bin/env python

import urllib2
from urllib import urlencode
import string
import plistlib
import sqlite3
from sqlite3 import IntegrityError

class HintDB(object):
    def __init__(self, db_file_path='hints.db', reset_data=False):
        self.conn = sqlite3.connect(db_file_path)
        self.cur = self.conn.cursor()
        self.create_tables(reset_data)
        self.last_key = None
    def close(self):
        self.conn.commit()
        self.conn.close()
    def create_tables(self, reset_data=False):
        if reset_data:
            self.conn.execute('drop table if exists hints')
            self.conn.execute('drop table if exists keys')
        self.conn.execute("CREATE TABLE IF NOT EXISTS hints (input text, strength integer, result text, created text default (strftime('%s', 'now')))")
        self.conn.execute("CREATE TABLE IF NOT EXISTS keys (key text primary key, created text default (strftime('%s', 'now')), last_checked text)")
        self.cur.execute("select count(*) from keys")
        num_keys = self.cur.fetchone()[0]
        if num_keys == 0:
            self.cur.executemany("insert into keys(key) values (:key)", [{'key':l} for l in string.letters[:26]])
    
    def add_key(self, key):
        success = False
        try:
            self.cur.execute("insert into keys(key) values(?)", (key,))
            self.conn.commit()
            success = True
        except IntegrityError, e:
            success = False
        return success

    def update_key_last_checked(self, key):
        self.cur.execute("update keys set last_checked = (strftime('%s', 'now')) where key = ?", (key,))
        self.conn.commit()

    def get_next_key(self):
        if self.last_key is None:
            self.cur.execute("select key from keys order by last_checked limit 1")
        else:
            self.cur.execute("select key from keys where key <> ? order by last_checked limit 1", (self.last_key,))
        res = self.cur.fetchone()
        if res is not None:
            key = res[0]
        else:
            key = None
        self.last_key = key
        return key
    
    def add_hint(self, input_key, strength, result):
        insert_query = 'insert into hints (input, strength, result) values (?, ?, ?)'
        self.cur.execute(insert_query, (input_key, strength, result))
        self.conn.commit()

MAX_KEY_LEN = 3
BASE_URL = 'http://ax.search.itunes.apple.com/WebObjects/MZSearchHints.woa/wa/hints' # ?q=

def get_hints(key):
    url = BASE_URL + '?' + urlencode({'q': key.encode("utf-8")})
    # print "opening url", url
    stream = urllib2.urlopen(url)
    plist = plistlib.readPlist(stream)
    hints = plist['hints']
    return hints
    

def main(reset_data=False):
    try:
        db = HintDB(reset_data=reset_data)
        key = db.get_next_key()
        while key is not None:
            print "key is", key
            hints = get_hints(key)
            print "got %d results for key %s" % (len(hints), key)
        
            for result in hints:
                term = result['term']
                # build keys off results
                i = 2
                while i < len(term) and i <= MAX_KEY_LEN:
                    t = term[:i]
                    db.add_key(t)
                    i += 1
                db.add_hint(key, result['priority'], term)
                print "- added result '%s' for key '%s'" % (result['term'], key)
            db.update_key_last_checked(key)
            key = db.get_next_key()
    except KeyboardInterrupt, e:
        print ""
        print "caught signal - close db and quit"
        db.close()
    

if __name__ == '__main__':
    reset_data = False
    import sys
    if len(sys.argv) == 2:
        if sys.argv[1] in ('1', 'true', 'True'):
            print "resetting data"
            reset_data = True
    main(reset_data)
