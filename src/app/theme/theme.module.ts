import { ModuleWithProviders, NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { RouterModule } from '@angular/router';
import { CapitalizePipe, DebouncePipe, DefaultPipe, NumberWithCommasPipe, PluralPipe, RoundPipe, TimingPipe } from './pipes';

const BASE_MODULES = [
    CommonModule,
    RouterModule,
];
const THEME_MODULES = [];
const COMPONENTS = [];
const ENTRY_COMPONENTS = [];
const PROVIDERS = [];
const PIPES = [
    DefaultPipe,
    DebouncePipe,
    CapitalizePipe,
    PluralPipe,
    RoundPipe,
    TimingPipe,
    NumberWithCommasPipe,
];

@NgModule({
    imports: [
        ...BASE_MODULES,
        ...THEME_MODULES,
    ],
    exports: [...BASE_MODULES, ...THEME_MODULES, ...COMPONENTS, ...PIPES],
    declarations: [...COMPONENTS, ...PIPES],
    entryComponents: [...ENTRY_COMPONENTS],
})
export class ThemeModule {
    static forRoot(): ModuleWithProviders<ThemeModule> {
        return {
            ngModule: ThemeModule,
            providers: [...PROVIDERS],
        } as ModuleWithProviders<ThemeModule>;
    }
}
