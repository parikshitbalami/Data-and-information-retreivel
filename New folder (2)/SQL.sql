create schema Clinton_Management;
use Clinton_Management;
CREATE TABLE staff (
    staff_id INT,
    staff_fname VARCHAR(50),
    staff_lname VARCHAR(50),
    CONSTRAINT pk_staff PRIMARY KEY (staff_id)
);
select * from staff;

CREATE TABLE part (
    part_id VARCHAR(3),
    part_name VARCHAR(100),
    CONSTRAINT pk_part PRIMARY KEY (part_id)
);
select * from part;

CREATE TABLE property_type (
    type_id VARCHAR(5),
    type VARCHAR(100),
    CONSTRAINT pk_ptype PRIMARY KEY (type_id)
);
select * from property_type;

CREATE TABLE client (
    client_id INT,
    client_fname VARCHAR(50),
    client_lname VARCHAR(50),
    CONSTRAINT pk_client PRIMARY KEY (client_id)
);
select * from client;

CREATE TABLE tenant_type (
    type_id VARCHAR(5),
    type VARCHAR(100),
    CONSTRAINT pk_ttype PRIMARY KEY (type_id)
);
select * from tenant_type;

CREATE TABLE tenant (
    tenant_id VARCHAR(5),
    tenant_name VARCHAR(200),
    tenant_type VARCHAR(5),
    CONSTRAINT pk_tenant PRIMARY KEY (tenant_id),
    CONSTRAINT fk_tenant FOREIGN KEY (tenant_type)
        REFERENCES tenant_type (type_id)
);
select * from tenant;
CREATE TABLE portfolio (
    portfolio_id INT,
    client_id INT,
    CONSTRAINT pk_port PRIMARY KEY (portfolio_id),
    CONSTRAINT fk_port FOREIGN KEY (client_id)
        REFERENCES client (client_id)
);
select * from portfolio;

CREATE TABLE property (
    property_id INT,
    property_address VARCHAR(200),
    type_id VARCHAR(5),
    portfolio_id INT,
    CONSTRAINT pk_pro PRIMARY KEY (property_id),
    CONSTRAINT fk_pro1 FOREIGN KEY (type_id)
        REFERENCES property_type (type_id)
        ON DELETE CASCADE,
    CONSTRAINT fk_pro2 FOREIGN KEY (portfolio_id)
        REFERENCES portfolio (portfolio_id)
        ON DELETE CASCADE
);
select * from property;

CREATE TABLE property_tenant (
    property_id INT,
    tenant_id VARCHAR(5),
    start_date DATE,
    end_date DATE,
    monthly_rent INT,
    CONSTRAINT FOREIGN KEY (property_id)
        REFERENCES property (property_id)
        ON DELETE CASCADE,
    CONSTRAINT FOREIGN KEY (tenant_id)
        REFERENCES tenant (tenant_id)
        ON DELETE CASCADE
);
select * from property_tenant;
CREATE TABLE repair (
    repair_id INT AUTO_INCREMENT,
    repair_detail VARCHAR(1000),
    property_id INT,
    CONSTRAINT pk_repair PRIMARY KEY (repair_id),
    CONSTRAINT fk_repair FOREIGN KEY (property_id)
        REFERENCES property (property_id)
        ON DELETE CASCADE
);
select * from property_tenant;
CREATE TABLE staff_repair (
    staff_id INT,
    repair_id INT,
    CONSTRAINT fk_sr1 FOREIGN KEY (staff_id)
        REFERENCES staff (staff_id),
    CONSTRAINT fk_sr2 FOREIGN KEY (repair_id)
        REFERENCES repair (repair_id)
);
select * from staff_repair;

CREATE TABLE part_repair (
    part_id VARCHAR(3),
    repair_id INT,
    qty INT,
    CONSTRAINT fk_pr1 FOREIGN KEY (part_id)
        REFERENCES part (part_id),
    CONSTRAINT fk_pr2 FOREIGN KEY (repair_id)
        REFERENCES repair (repair_id)
);
select * from part_repair;
insert into client values    (23, "Roger", "Picard"),
    (11, "Alison", "Brown");
INSERT into portfolio VALUES    (201,23), (203,23), (301,11);
insert into tenant_type values ("B", "Buisness"), ("P", "Private"), ("G", "Government");
insert into tenant values("T77", "Gaslight Software", "B"), ("T99","Michell Throssell", "P"), ("T81","Edgar Kanne", "P"),
                        ("T88", "Helpline One-Stop Shop", "G"), ("T100","Dewitt Julio", "P"), ("T101","Charisse Spinello", "P");
insert into property_type values("RH", "Residental House"), ("RF", "Residental Flat"), ("CP", "Comercial Property");
insert into property values(2431, "80 Overmeer Rd, SE15 6NQ", "RH",201), (8901,"99a Queen Street, N1 2ER", "RF", 201), (9088,"23 Redding Yard, Bromley-byBow, E2 89Y","CP", 203),
                            (1990,"23 St Anne’s Place, N1 8RR", "CP", 203), (3099, "99 Kings Street, N1 988", "RH", 301), (3097,"11 Kings Street, N1 988", "RH", 301);
insert into property_tenant values (1990, "T77", "2005-03-01", "2018-03-01", 1000), (2431, "T99", "2017-03-01","2018-03-01", 2500), (8901,"T81", "2017-04-03", "2017-04-01", 2000),
                                (9088,"T88","2017-03-01","2021-03-01",1500), (3099,"T100", "2017-03-01", "2017-12-01", 1000), (3097,"T101", "2017-01-01","2018-02-01",5500);
insert into repair value(1,"Replacement Front windows", 2431);
insert into staff values(78, "Dave", "Smith"),(23,"Holly", "Leman");
insert into part values ("SF", "Standard Frame"), ("WF", "Window Fitting");
insert into part_repair values ("SF",1,4), ("WF",1,4);
insert into staff_repair values (78,1), (23,1);

-- a.   Write a query that selects all the portfolios and properties for a particular owner.      
SELECT    *
FROM    client AS c,
    portfolio AS p,
    property AS pr
WHERE    c.client_id = p.client_id
        AND p.portfolio_id = pr.portfolio_id;
        
-- b.   Write a query that selects the tenants and their tenancy dates.
SELECT    t.tenant_name, tp.start_date, tp.end_date
FROM    tenant AS t,
    property_tenant AS tp
WHERE    t.tenant_id = tp.tenant_id;


-- c.   Write a query that shows all parts involved in the repair of a particular property.       
SELECT    *
FROM    repair AS r,
    part_repair AS pr,
    part AS p
WHERE    r.repair_id = pr.repair_id
        AND pr.part_id = p.part_id;
        
-- d.   Write a query that shows all the tenants for a particularowner.
SELECT    c.client_fname, t.tenant_name

FROM    client AS c,
    portfolio AS p,
    property AS pr,
    property_tenant AS pt,
    tenant AS t
WHERE    c.client_id = p.client_id
        AND p.portfolio_id = pr.portfolio_id
        AND pr.property_id = pt.property_id
        AND pt.tenant_id = t.tenant_id;
 -- e.  Write a query that produces the output that could be used to show all the details of staff working on a repair job on a property.
 SELECT    p.property_id,
    p.property_address,
    s.staff_fname,
    s.staff_lname
FROM    property AS p,
    repair AS r,
    staff_repair AS sr,
    staff AS s
WHERE    p.property_id = r.property_id
        AND r.repair_id = sr.repair_id
        AND sr.staff_id = s.staff_id;
 -- f.  Write a query that delete all the details of a property whose address is “80 Overmeer Rd, SE15 6NQ”.
 DELETE FROM property 
WHERE    property_address = '80 Overmeer Rd, SE15 6NQ';