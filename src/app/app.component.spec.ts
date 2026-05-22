import { AppComponent } from './app.component';

describe('AppComponent', () => {
  it('should create the app component', () => {
    const app = new AppComponent();
    expect(app).toBeTruthy();
  });

  it('should define the CI/CD title', () => {
    const app = new AppComponent();
    expect(app.title).toContain('CI/CD');
  });

  it('should expose the key pipeline metrics', () => {
    const app = new AppComponent();
    expect(app.metrics.length).toBe(3);
    expect(app.stages.length).toBe(5);
    expect(app.checkpoints.length).toBe(3);
  });
});
