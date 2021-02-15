import { Component, OnDestroy, OnInit } from '@angular/core';
import { EntitasService } from '../core/services/entitas.service';
import { BehaviorSubject, Subscription } from 'rxjs';
import { EntitasContextInfo, EntitasEntitySummary } from '../core/models/entitas';
import { TreeviewConfig, TreeviewItem } from 'ngx-treeview';
import { debounceTime, distinctUntilChanged } from 'rxjs/operators';

@Component({
    selector: 'app-home',
    templateUrl: './home.component.html',
    styleUrls: ['./home.component.scss']
})
export class HomeComponent implements OnInit, OnDestroy {
    private subscriptions: Subscription[] = [];
    public contexts: BehaviorSubject<TreeviewItem[]> = new BehaviorSubject<TreeviewItem[]>([]);
    public components: BehaviorSubject<TreeviewItem[]> = new BehaviorSubject<TreeviewItem[]>([]);
    public entities: BehaviorSubject<EntitasEntitySummary[]> = new BehaviorSubject<EntitasEntitySummary[]>([]);

    private selectedContexts: BehaviorSubject<EntitasContextInfo[]> = new BehaviorSubject<EntitasContextInfo[]>([]);
    private selectedComponents: BehaviorSubject<string[]> = new BehaviorSubject<string[]>([]);

    private colors = [
        'primary',
        'secondary',
        'success',
        'danger',
        'warning',
        'info',
        'light',
        'dark',
    ];

    public config = TreeviewConfig.create({
        hasAllCheckBox: false,
        hasFilter: false,
        hasCollapseExpand: false,
        decoupleChildFromParent: false,
        maxHeight: 500
    });

    constructor(private entitasService: EntitasService) {
        this.subscriptions.push(this.entitasService.contexts.subscribe(value => {
            if (value) {
                this.formatContexts(value);
            }
        }));

        this.subscriptions.push(this.selectedContexts
            .pipe(
                debounceTime(10),
                distinctUntilChanged(),
            )
            .subscribe(value => {
                this.updateComponentList(value);
            })
        );

        this.subscriptions.push(this.selectedComponents
            .pipe(
                debounceTime(10),
                distinctUntilChanged(),
            )
            .subscribe(value => {
                this.updateEntityList(value);
            })
        );
    }


    ngOnInit(): void {
    }

    ngOnDestroy(): void {
        this.subscriptions.forEach((subscription) => subscription.unsubscribe());
    }

    private formatContexts(cList: EntitasContextInfo[]): void {
        const list: TreeviewItem[] = [];
        let index = 0;
        cList.forEach(value => {
            index = index + 1;
            const item = new TreeviewItem({
                text: value.name,
                value,
                children: [],
                collapsed: true,
                // checked: false,
            });
            list.push(item);
        });

        this.contexts.next([
            new TreeviewItem({
                text: 'Contexts',
                value: 1,
                children: list,
                checked: true,
            })
        ]);
    }

    private formatComponents(context: EntitasContextInfo): TreeviewItem[] {
        const list: TreeviewItem[] = [];
        context.component_names.forEach(name => {
            const item = new TreeviewItem({
                text: name,
                value: name,
                children: [],
                collapsed: true,
                checked: true,
            });
            list.push(item);
        });
        return list;
    }

    public onSelectedContextChange(event: EntitasContextInfo[]): void {
        this.selectedContexts.next(event);
    }

    public onSelectedComponentChange(event: string[]): void {
        this.selectedComponents.next(event);
    }

    private updateComponentList(value: EntitasContextInfo[]): void {
        let list: TreeviewItem[] = [];
        value.forEach(v => {
            list = list.concat(this.formatComponents(v));
        });

        this.components.next([
            new TreeviewItem({
                text: 'Components',
                value: 1,
                children: list,
            })
        ]);
    }

    private updateEntityList(compNames: string[]): void {
        this.entities.next([]);
        let list: EntitasEntitySummary[] = [];
        const contexts = this.selectedContexts.getValue();
        for (const cont of contexts) {
            this.entitasService.getContextEntities(cont.name)
                .toPromise()
                .then((entities: EntitasEntitySummary[]) => {
                    list = list.concat(entities);
                    this.entities.next(list);
                });
        }
    }

    get entityList(): EntitasEntitySummary[] {
        return this.entities.getValue();
    }

    public getContextColor(name: string): string {
        console.log(name);
        const index = this.selectedContexts.getValue().findIndex(value => {
            return value.name === name;
        });

        if (index > -1 && index < this.colors.length) {
            return this.colors[index];
        }

        return 'none';
    }

    public getComponentColor(name: string): string {
        console.log(name);
        const index = this.selectedComponents.getValue().findIndex(value => {
            if (value === name) {
                return true;
            } else {
                return value.endsWith(name);
            }
        });

        if (index > -1 && index < this.colors.length) {
            return this.colors[index];
        } else if (index > -1) {
            return `none-${index}`;
        }
        return 'none';
    }
}
