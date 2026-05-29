import styles from './UI.module.scss';

export default function Button({ 
  children, 
  variant = 'primary', 
  onClick, 
  className = '',
  type = 'button'
}) {
  return (
    <button
      type={type}
      onClick={onClick}
      className={`${styles.button} ${styles[variant]} ${className}`}
    >
      {children}
    </button>
  );
}
