package ${PACKAGE};

import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Table;

@Entity
@Table(name = "${TABLE}")
public class ${NAME} {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

}
