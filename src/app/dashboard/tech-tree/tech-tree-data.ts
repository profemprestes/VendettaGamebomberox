
export type Requirement = {
    name: string;
    level: number;
};
  
export type TechItem = {
    id: string;
    name: string;
    image: string;
    available: boolean;
    requirements: Requirement[];
};
  
export const roomsTechData: TechItem[] = [
    {
        id: "oficina-jefe",
        name: "Oficina del Jefe",
        image: "room-office",
        available: true,
        requirements: [],
    },
    {
        id: "escuela-especializacion",
        name: "Escuela de especialización",
        image: "room-specialization",
        available: true,
        requirements: [],
    },
    {
        id: "armeria",
        name: "Armería",
        image: "room-armory",
        available: true,
        requirements: [],
    },
    {
        id: "almacen-municion",
        name: "Almacén de munición",
        image: "room-ammo",
        available: true,
        requirements: [],
    },
    {
        id: "cerveceria",
        name: "Cervecería",
        image: "room-brewery",
        available: true,
        requirements: [],
    },
    {
        id: "taberna",
        name: "Taberna",
        image: "room-tavern",
        available: false,
        requirements: [{ name: "Cervecería", level: 1 }],
    },
    {
        id: "contrabando",
        name: "Contrabando",
        image: "room-contraband",
        available: false,
        requirements: [
            { name: "Oficina del Jefe", level: 5 },
            { name: "Cervecería", level: 8 }
        ],
    },
    {
        id: "almacen-armas",
        name: "Almacén de armas",
        image: "room-armory",
        available: false,
        requirements: [{ name: "Armería", level: 5 }],
    },
    {
        id: "deposito-municion",
        name: "Depósito de munición",
        image: "room-ammo",
        available: false,
        requirements: [{ name: "Almacén de munición", level: 5 }],
    },
    {
        id: "almacen-alcohol",
        name: "Almacén de alcohol",
        image: "room-brewery",
        available: false,
        requirements: [{ name: "Cervecería", level: 5 }],
    },
    {
        id: "caja-fuerte",
        name: "Caja fuerte",
        image: "room-vault",
        available: false,
        requirements: [{ name: "Taberna", level: 5 }],
    },
    {
        id: "campo-entrenamiento",
        name: "Campo de entrenamiento",
        image: "room-training",
        available: true,
        requirements: [],
    },
    {
        id: "seguridad",
        name: "Seguridad",
        image: "room-security",
        available: false,
        requirements: [{ name: "Campo de entrenamiento", level: 2 }],
    },
    {
        id: "torreta-fuego-automatico",
        name: "Torreta de fuego automático",
        image: "room-turret",
        available: false,
        requirements: [{ name: "Oficina del Jefe", level: 5 }],
    },
    {
        id: "minas-ocultas",
        name: "Minas ocultas",
        image: "room-mines",
        available: false,
        requirements: [{ name: "Oficina del Jefe", level: 5 }],
    },
];
