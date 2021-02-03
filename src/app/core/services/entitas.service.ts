import { Injectable } from '@angular/core';
import { environment } from '../../../environments/environment';
import { catchError } from 'rxjs/operators';
import { HttpClient, HttpErrorResponse } from '@angular/common/http';
import { Observable, throwError } from 'rxjs';
import { HttpReqConfig } from '../models/http_req_config';

@Injectable({
    providedIn: 'root'
})
export class EntitasService {
    private baseUrl: string = environment.api_endpoint;

    constructor(private http: HttpClient) {
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
    public handleError(error: HttpErrorResponse) {
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
}
