// To parse this data:
//
//   import { Convert } from "./file";
//
//   const contexts = Convert.toContexts(json);

export interface Context {
    name: string;
    size: number;
    entities: Entity[];
    components: string[];
    creation_index: number;
    info: Info;
    reusable_entities: number;
    retained_entities: number;
    component_pools: { [key: string]: number };
    groups_for_index: Array<GroupsForIndex[]>;
}

export interface Info {
    name: string;
    component_names: string[];
    component_types: string[];
}

export interface Entity {
    name: string;
    creation_index: number;
    component_indices: number[];
    components: Array<EntityComponent | null>;
    context_info: any;
    retain_count: number;
}

export interface EntityComponent {
    name: string;
    unique: boolean;
    data: any;
}

export interface GroupsForIndex {
    matcher: string;
    entities: Entity[];
}

// Converts JSON strings to/from your types
export class Convert {
    public static toContexts(json: string): Context[] {
        return JSON.parse(json);
    }

    public static contextsToJson(value: Context[]): string {
        return JSON.stringify(value);
    }
}
