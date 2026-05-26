import org.junit.jupiter.api.*;
import static org.junit.jupiter.api.Assertions.*;

public class SampleTest {
    Sample sut;

    @BeforeEach
    void setUp() {
        sut = new Sample();
    }

    @Test
    void testExample() {
        assertEquals(1, sut.example());
    }
}
