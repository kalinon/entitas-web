import { Injectable } from '@angular/core';
import { environment } from '../../../environments/environment';
import { catchError } from 'rxjs/operators';
import { HttpClient, HttpErrorResponse } from '@angular/common/http';
import { BehaviorSubject, Observable, throwError } from 'rxjs';
import { HttpReqConfig } from '../models/http_req_config';
import {
    EntitasContext,
    EntitasContextInfo,
    EntitasEntity,
    EntitasEntitySummary,
    EntitasGroup,
    EntitasSystemList
} from '../models/entitas';

@Injectable({
    providedIn: 'root'
})
export class EntitasService {
    private baseUrl: string = environment.api_endpoint;

    public contexts = new BehaviorSubject<EntitasContextInfo[]>(null);

    constructor(private http: HttpClient) {
        this.getContexts().toPromise().then(value => {
            this.contexts.next(value);
        });
    }

    private getResources<T>(resource: string, headers?: { [header: string]: string | string[]; }): Observable<T[]> {
        return this.http.get<T[]>(this.baseUrl + '/api/v1/' + resource, this.getConfig(headers))
            .pipe(
                catchError(this.handleError)
            );
    }

    // tslint:disable-next-line:max-line-length
    private getResource<T>(resource: string, headers?: { [header: string]: string | string[]; }, params?: { [key: string]: string | string[]; }): Observable<T> {
        return this.http.get<T>(this.baseUrl + '/api/v1/' + resource, this.getConfig(headers, params))
            .pipe(
                catchError(this.handleError)
            );
    }

    private getConfig(headers?: { [header: string]: string | string[]; }, params?: { [param: string]: string | string[]; }): HttpReqConfig {
        return {
            responseType: 'json',
            headers,
            params,
        };
    }

    // tslint:disable-next-line:typedef
    private handleError(error: HttpErrorResponse) {
        if (!environment.production) {
            if (error.error instanceof ErrorEvent) {
                // A client-side or network error occurred. Handle it accordingly.
                console.error('An error occurred:', error.error.message);
            } else {
                if (error.status === 401) {
                    // Failed to auth
                } else if (environment.production !== true) {
                    // The backend returned an unsuccessful response code.
                    // The response body may contain clues as to what went wrong,
                    console.error(
                        `Backend returned code ${error.status}, ` +
                        `body was: ${error.error}`);
                }

                // return an observable with a user-facing error message
                return throwError('Something bad happened; please try again later.');
            }
        }
    }

    public getSystemsNames(): Observable<string[]> {
        return this.getResources<string>('systems');
    }

    public getSystem(name: string): Observable<EntitasSystemList> {
        return this.getResource<EntitasSystemList>(`systems/${name}`);
    }

    public getController(): Observable<EntitasSystemList> {
        return this.getResource<EntitasSystemList>(`controller`);
    }

    public getContexts(): Observable<EntitasContextInfo[]> {
        return this.getResources<EntitasContextInfo>('contexts');
    }

    public getContext(name: string): Observable<EntitasContext> {
        return this.getResource<EntitasContext>(`contexts/${name}`);
    }

    public getContextEntities(name: string): Observable<EntitasEntitySummary[]> {
        return this.getResources<EntitasEntitySummary>(`contexts/${name}/entities`);
    }

    public getContextEntity(name: string, index: number): Observable<EntitasEntity> {
        return this.getResource<EntitasEntity>(`contexts/${name}/entities/${index}`);
    }

    public getContextGroups(name: string): Observable<EntitasGroup[]> {
        return this.getResources<EntitasGroup>(`contexts/${name}/groups`);
    }
}
