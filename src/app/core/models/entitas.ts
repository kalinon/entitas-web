export interface EntitasSystemList {
    name: string;
    systems: EntitasSystem[];
}

export interface EntitasSystem {
    name: string;
    systems?: EntitasSystem[];
    collector?: EntitasCollector;
    collectors?: EntitasCollector[];
}

export interface EntitasCollector {
    name: string;
    groups: EntitasGroup[];
    group_events: number[];
}

export interface EntitasGroup {
    matcher: string;
    entities: EntitasEntity[];
}

export interface EntitasContextInfo {
    name: string;
    component_names: string[];
    component_types: string[];
}

export interface EntitasContext {
    name: string;
    total_entities: number;
    components: string[];
    creation_index: number;
    reusable_entities: number;
    retained_entities: number;
}

export interface EntitasEntitySummary {
    name: string;
    creation_index: number;
    context: string;
    components: string[];
}

export interface EntitasEntity {
    name: string;
    creation_index: number;
    context: string;
    components: EntitasComponent[];
}

export interface EntitasComponent {
    name: string;
    unique: boolean;
    data: any;
}
