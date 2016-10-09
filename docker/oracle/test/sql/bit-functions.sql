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

--
-- https://community.oracle.com/thread/498773
-- http://www.orafaq.com/wiki/Bit


-- BITOR
CREATE FUNCTION "BITOR" (x IN NUMBER, y IN NUMBER) RETURN NUMBER AS
    BEGIN
      RETURN ((x + y) - BITAND(x, y));
    END;
/
GRANT EXECUTE ON BITOR TO PUBLIC;


-- BITXOR
CREATE FUNCTION "BITXOR" (x IN NUMBER, y IN NUMBER) RETURN NUMBER AS
    BEGIN
      RETURN (BITOR(x, y) - BITAND(x, y));
    END;
/
GRANT EXECUTE ON BITXOR TO PUBLIC;

-- BITNOT
CREATE FUNCTION "BITNOT" (x IN NUMBER) RETURN NUMBER AS
    BEGIN
      --RETURN (-1 - x);
      RETURN (0 - x) - 1 ;
    END;
/
GRANT EXECUTE ON BITNOT TO PUBLIC;

