import ProfileShell from '../pages/profile/ProfileShell';
import ProjectShell from '../pages/projects/ProjectShell';

export default function Routes({ activeSection, setActiveSection }) {
  if (activeSection === 'projects') {
    return <ProjectShell onNavigate={setActiveSection} />;
  }
  return <ProfileShell onNavigate={setActiveSection} />;
}
