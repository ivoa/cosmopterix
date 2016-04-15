--
-- <meta:header>
--   <meta:licence>
--     Copyright (c) 2016, ROE (http://www.roe.ac.uk/)
--
--     This information is free software: you can redistribute it and/or modify
--     it under the terms of the GNU General Public License as published by
--     the Free Software Foundation, either version 3 of the License, or
--     (at your option) any later version.
--
--     This information is distributed in the hope that it will be useful,
--     but WITHOUT ANY WARRANTY; without even the implied warranty of
--     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
--     GNU General Public License for more details.
--  
--     You should have received a copy of the GNU General Public License
--     along with this program.  If not, see <http://www.gnu.org/licenses/>.
--   </meta:licence>
-- </meta:header>
--
--

CREATE TABLE alpha_source
    (
    id   INTEGER NOT NULL,
    ra   DOUBLE PRECISION NOT NULL,
    decl DOUBLE PRECISION NOT NULL,
    PRIMARY KEY (id)
    );

CREATE SEQUENCE alpha_source_id_seq
    START WITH  1
    INCREMENT BY 1
    MINVALUE 1
    ;

CREATE TRIGGER alpha_source_id_trig
    BEFORE INSERT ON alpha_source
    FOR EACH ROW
    BEGIN
        :NEW.id := alpha_source_id_seq.NEXTVAL;
    END;
    /

INSERT INTO alpha_source (ra, decl) VALUES (0.0,  0.0) ;
INSERT INTO alpha_source (ra, decl) VALUES (0.0,  1.0) ;
INSERT INTO alpha_source (ra, decl) VALUES (0.0,  2.0) ;
INSERT INTO alpha_source (ra, decl) VALUES (0.0,  3.0) ;
INSERT INTO alpha_source (ra, decl) VALUES (0.0,  4.0) ;
INSERT INTO alpha_source (ra, decl) VALUES (0.0,  5.0) ;
INSERT INTO alpha_source (ra, decl) VALUES (0.0,  6.0) ;
INSERT INTO alpha_source (ra, decl) VALUES (0.0,  7.0) ;
INSERT INTO alpha_source (ra, decl) VALUES (0.0,  8.0) ;
INSERT INTO alpha_source (ra, decl) VALUES (0.0,  9.0) ;

INSERT INTO alpha_source (ra, decl) VALUES (0.0, 10.0) ;
INSERT INTO alpha_source (ra, decl) VALUES (0.0, 11.0) ;
INSERT INTO alpha_source (ra, decl) VALUES (0.0, 12.0) ;
INSERT INTO alpha_source (ra, decl) VALUES (0.0, 13.0) ;
INSERT INTO alpha_source (ra, decl) VALUES (0.0, 14.0) ;
INSERT INTO alpha_source (ra, decl) VALUES (0.0, 15.0) ;
INSERT INTO alpha_source (ra, decl) VALUES (0.0, 16.0) ;
INSERT INTO alpha_source (ra, decl) VALUES (0.0, 17.0) ;
INSERT INTO alpha_source (ra, decl) VALUES (0.0, 18.0) ;
INSERT INTO alpha_source (ra, decl) VALUES (0.0, 19.0) ;

INSERT INTO alpha_source (ra, decl) VALUES (0.0, 20.0) ;
INSERT INTO alpha_source (ra, decl) VALUES (0.0, 21.0) ;
INSERT INTO alpha_source (ra, decl) VALUES (0.0, 22.0) ;
INSERT INTO alpha_source (ra, decl) VALUES (0.0, 23.0) ;
INSERT INTO alpha_source (ra, decl) VALUES (0.0, 24.0) ;
INSERT INTO alpha_source (ra, decl) VALUES (0.0, 25.0) ;
INSERT INTO alpha_source (ra, decl) VALUES (0.0, 26.0) ;
INSERT INTO alpha_source (ra, decl) VALUES (0.0, 27.0) ;
INSERT INTO alpha_source (ra, decl) VALUES (0.0, 28.0) ;
INSERT INTO alpha_source (ra, decl) VALUES (0.0, 29.0) ;

INSERT INTO alpha_source (ra, decl) VALUES (0.0, 30.0) ;
INSERT INTO alpha_source (ra, decl) VALUES (0.0, 31.0) ;
INSERT INTO alpha_source (ra, decl) VALUES (0.0, 32.0) ;
INSERT INTO alpha_source (ra, decl) VALUES (0.0, 33.0) ;
INSERT INTO alpha_source (ra, decl) VALUES (0.0, 34.0) ;
INSERT INTO alpha_source (ra, decl) VALUES (0.0, 35.0) ;
INSERT INTO alpha_source (ra, decl) VALUES (0.0, 36.0) ;
INSERT INTO alpha_source (ra, decl) VALUES (0.0, 37.0) ;
INSERT INTO alpha_source (ra, decl) VALUES (0.0, 38.0) ;
INSERT INTO alpha_source (ra, decl) VALUES (0.0, 39.0) ;

INSERT INTO alpha_source (ra, decl) VALUES (0.0, 40.0) ;
INSERT INTO alpha_source (ra, decl) VALUES (0.0, 41.0) ;
INSERT INTO alpha_source (ra, decl) VALUES (0.0, 42.0) ;
INSERT INTO alpha_source (ra, decl) VALUES (0.0, 43.0) ;
INSERT INTO alpha_source (ra, decl) VALUES (0.0, 44.0) ;
INSERT INTO alpha_source (ra, decl) VALUES (0.0, 45.0) ;


