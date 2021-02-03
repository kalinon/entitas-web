import { TestBed } from '@angular/core/testing';

import { EntitasService } from './entitas.service';

describe('EntitasService', () => {
  let service: EntitasService;

  beforeEach(() => {
    TestBed.configureTestingModule({});
    service = TestBed.inject(EntitasService);
  });

  it('should be created', () => {
    expect(service).toBeTruthy();
  });
});
