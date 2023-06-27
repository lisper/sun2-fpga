/* cosim_mc68010.c */
/*
 * PLI interface to mc68010 software simulator
 */

#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <fcntl.h>
#include <pthread.h>

#ifdef unix
#include <unistd.h>
#endif

#ifdef __CVER__
#include "vpi_user.h"
#include "cv_vpi_user.h"

PLI_INT32 pli_cosim(void);
extern void register_my_systfs(void); 
#endif

#include "m68k.h"

pthread_t thread;
volatile int state;

int rw_pending = 0;
unsigned rw_addr = 0;
unsigned rw_size = 0;
unsigned rw_value = 0;
int rw_read = 0;
unsigned rw_write = 0;
pthread_cond_t rw_cond  = PTHREAD_COND_INITIALIZER;
pthread_mutex_t rw_mutex = PTHREAD_MUTEX_INITIALIZER;
int cpu_trace = 0;

enum {
    S_RAW = 0,
    S_INIT,
    S_RUN,
    S_PENDING_RW,
    S_WAIT_RW,
    S_DONE_RW,
};

void dump_cpu()
{
#if 1
    vpi_printf("PC %06x sr %04x usp %06x isp %06x sp %06x\n",
               m68k_get_reg(NULL, M68K_REG_PC),
              m68k_get_reg(NULL, M68K_REG_SR),
               m68k_get_reg(NULL, M68K_REG_USP),
               m68k_get_reg(NULL, M68K_REG_ISP),
               m68k_get_reg(NULL, M68K_REG_SP));

    //vpi_printf("%04x %s\n", m68k_read_memory_16(pc), buf);

    vpi_printf("A0:%08x A1:%08x A2:%08x A3:%08x A4:%08x A5:%08x A6:%08x A7:%08x\n",
               m68k_get_reg(NULL, M68K_REG_A0), m68k_get_reg(NULL, M68K_REG_A1),
               m68k_get_reg(NULL, M68K_REG_A2), m68k_get_reg(NULL, M68K_REG_A3),
               m68k_get_reg(NULL, M68K_REG_A4), m68k_get_reg(NULL, M68K_REG_A5),
               m68k_get_reg(NULL, M68K_REG_A6), m68k_get_reg(NULL, M68K_REG_A7));

    vpi_printf("D0:%08x D1:%08x D2:%08x D3:%08x D4:%08x D5:%08x D6:%08x D7:%08x\n",
               m68k_get_reg(NULL, M68K_REG_D0), m68k_get_reg(NULL, M68K_REG_D1),
               m68k_get_reg(NULL, M68K_REG_D2), m68k_get_reg(NULL, M68K_REG_D3),
               m68k_get_reg(NULL, M68K_REG_D4), m68k_get_reg(NULL, M68K_REG_D5),
               m68k_get_reg(NULL, M68K_REG_D6), m68k_get_reg(NULL, M68K_REG_D7));
#endif
}

static void rw_wait(int _size, unsigned addr, unsigned value, int is_read)
{
    int rc;
    
    rc = pthread_mutex_lock(&rw_mutex);
    if (rc) perror("pthread_mutex_lock");

    rw_pending = 1;
    rw_size = _size;
    rw_addr = addr;
    rw_read = is_read;
    rw_write = value;
    state = S_PENDING_RW;
    
    while (rw_pending) {
        //printf("rw_wait Thread blocked\n");
        rc = pthread_cond_wait(&rw_cond, &rw_mutex);
        //printf("rw_wait backfrom pthread_cond_wait\n");
    }

    rc = pthread_mutex_unlock(&rw_mutex);
    if (rc) perror("pthread_mutex_unlock");
}

void cpu_progress()
{
#if 0
    static int delay = 0;
    if (++delay > 5000) {
        delay = 0;
        dump_cpu();
        fflush(stdout);
    }
#endif
}

unsigned int m68k_read_memory_8(unsigned int address)
{
    cpu_progress();
    //printf("entry m68k_read_memory_8(%08x)\n", address);
    rw_wait(1, address, 0, 1);
//    if (cpu_trace) printf("exit m68k_read_memory_8(%08x) %04x\n", address, rw_value);
    return rw_value;
}

unsigned int m68k_read_memory_16(unsigned int address)
{
    cpu_progress();
//    if (cpu_trace) printf("entry m68k_read_memory_16(%08x)\n", address);
    rw_wait(2, address, 0, 1);
//    if (cpu_trace) printf("exit m68k_read_memory_16(%08x) %04x\n", address, rw_value);
    return rw_value;
}

unsigned int m68k_read_memory_32(unsigned int address)
{
    cpu_progress();
//    if (cpu_trace) printf("entry m68k_read_memory_32(%08x)\n", address);
    rw_wait(4, address, 0, 1);
//    if (cpu_trace) printf("exit m68k_read_memory_32(%08x) %08x\n", address, rw_value);
    return rw_value;
}

void m68k_write_memory_8(unsigned int address, unsigned int value)
{
    //dump_cpu();
    //printf("entry m68k_write_memory_8(%08x) %02x\n", address, value);
    rw_wait(1, address, value, 0);
}

void m68k_write_memory_16(unsigned int address, unsigned int value)
{
    //dump_cpu();
    //printf("entry m68k_write_memory_16(%08x) %04x\n", address, value);
    rw_wait(2, address, value, 0);
}

void m68k_write_memory_32(unsigned int address, unsigned int value)
{
    //printf("entry m68k_write_memory_32(%08x) %08x\n", address, value);
    rw_wait(4, address, value, 0);
}

int g_fc;

void set_fc_handler_function(int fc)
{
    g_fc = fc;
}

void trace_all()
{
//  unsigned int pc;
//  char buf[256];
//  pc = m68k_get_reg(NULL, M68K_REG_PC);
//  m68k_disassemble(buf, pc, M68K_CPU_TYPE_68010); 

  printf("\n");
  printf("PC %06x sr %04x usp %06x isp %06x sp %06x\n",
	 m68k_get_reg(NULL, M68K_REG_PC),
	 m68k_get_reg(NULL, M68K_REG_SR),
	 m68k_get_reg(NULL, M68K_REG_USP),
	 m68k_get_reg(NULL, M68K_REG_ISP),
	 m68k_get_reg(NULL, M68K_REG_SP));

//  printf("%s\n", buf);

  printf("D0:%08x D1:%08x D2:%08x D3:%08x D4:%08x D5:%08x D6:%08x D7:%08x\n",
	  m68k_get_reg(NULL, M68K_REG_D0), m68k_get_reg(NULL, M68K_REG_D1),
	  m68k_get_reg(NULL, M68K_REG_D2), m68k_get_reg(NULL, M68K_REG_D3),
	  m68k_get_reg(NULL, M68K_REG_D4), m68k_get_reg(NULL, M68K_REG_D5),
	  m68k_get_reg(NULL, M68K_REG_D6), m68k_get_reg(NULL, M68K_REG_D7));

  printf("A0:%08x A1:%08x A2:%08x A3:%08x A4:%08x A5:%08x A6:%08x A7:%08x\n",
	 m68k_get_reg(NULL, M68K_REG_A0), m68k_get_reg(NULL, M68K_REG_A1),
	 m68k_get_reg(NULL, M68K_REG_A2), m68k_get_reg(NULL, M68K_REG_A3),
	 m68k_get_reg(NULL, M68K_REG_A4), m68k_get_reg(NULL, M68K_REG_A5),
	 m68k_get_reg(NULL, M68K_REG_A6), m68k_get_reg(NULL, M68K_REG_A7));
}

void *thread_start(void *arg)
{
    //printf("entry thread_start()\n");
    m68k_set_cpu_type(M68K_CPU_TYPE_68010);
    m68k_init();
    m68k_pulse_reset();

    while (1) {
        //printf("thread: calling m68k_execute\n");
        if (cpu_trace) trace_all();
        m68k_execute(1);
        //printf("thread: backfrom m68k_execute\n");
    }
    
    //printf("exit thread_start()\n");
}

static int _init = 0;

static void init()
{
    int ret;
    if (_init) return;
    
    //printf("enter init; calling pthread_create\n");
    ret = pthread_create(&thread, NULL, thread_start, NULL);
    if (ret) perror("pthread_create");
    usleep(1000);
    //printf("exit init\n");
    _init = 1;
}

void finish()
{
    int ret;
    ret = pthread_join(thread, NULL);
    //printf("ret %d\n", ret);
    (void)ret;
}


#ifdef __TEST__
typedef int PLI_INT32;
#endif

void finish_rw()
{
    int rc;
    //printf("finish_rw()\n");
    state = S_DONE_RW;

    rc = pthread_mutex_lock(&rw_mutex);
    rw_pending = 0;
    //printf("finish_rw() broadcast\n");
    rc = pthread_cond_broadcast(&rw_cond);
    if (rc) perror("pthread_cond_broadcast");
    rc = pthread_mutex_unlock(&rw_mutex);
    //printf("exit finish_rw()\n");
}

void run_sm()
{
    static int old_state;
    if (state != old_state) {
        //printf("state %d\n", state);
        old_state = state;
    }
    switch (state) {
    case S_RAW:
        state = S_INIT;
        break;
    case S_INIT:
        init();
        break;
    case S_RUN:
        break;
    case S_PENDING_RW:
        state = S_WAIT_RW;
        break;
    case S_WAIT_RW:
        if (rw_read == 0) state = S_DONE_RW;
        break;
    case S_DONE_RW:
        state = S_RUN;
        break;
    }
}

#if 0
char *instnam_tab[10]; 
int last_evh;

static int getadd_inst_id(vpiHandle mhref)
{
    register int i;
    char *chp;
 
    chp = vpi_get_str(vpiFullName, mhref);
    //vpi_printf("getadd_inst_id() %s\n", chp);

    for (i = 1; i <= last_evh; i++) {
        if (strcmp(instnam_tab[i], chp) == 0)
            return(i);
    }

    instnam_tab[++last_evh] = malloc(strlen(chp) + 1);
    strcpy(instnam_tab[last_evh], chp);

    //vpi_printf("getadd_inst_id() done %d\n", last_evh);
    return(last_evh);
} 
#endif

#ifndef __TEST__
#if 0
static vpiHandle get_vpi_driver(vpiHandle wref)
{
    int wtyp, drvtyp;
    vpiHandle drviter, drvref, parref;
    s_vpi_value tmpval;
    char sval[1024], s1[1024];
 
    /* need to provide string storage for get value */
    tmpval.value.str = sval;

    wtyp = vpi_get(vpiType, wref);
    drviter = vpi_iterate(vpiDriver, wref);
    for (;;)
    {
        if ((drvref = vpi_scan(drviter)) == NULL) break;

        drvtyp = vpi_get(vpiType, drvref);
        if (wtyp == vpiNetBit)
        {
            if (drvtyp != vpiNetBitDriver) continue;
            parref = vpi_handle(vpiParent, drvref); 
            if (vpi_compare_objects(wref, parref))
            {
                strcpy(s1, vpi_get_str(vpiType, drvref));
                tmpval.format = vpiBinStrVal; 
                vpi_get_value(drvref, &tmpval);
                vpi_printf("reusing %s bit driver of %s current value %s.\n",
                           s1, vpi_get_str(vpiFullName, parref), tmpval.value.str);

                return(drvref);
            }
        }
        else if (wtyp == vpiNet)
        {
            if (drvtyp != vpiNetDriver) continue;

            strcpy(s1, vpi_get_str(vpiType, drvref));
            tmpval.format = vpiBinStrVal; 
            vpi_get_value(drvref, &tmpval);
            vpi_printf("reusing %s entire net driver of %s current value %s.\n",
                       s1, vpi_get_str(vpiFullName, wref), tmpval.value.str);

            return(drvref);
        }
        else
        { 
            vpi_printf("**ERR: illegal value %s passed to get_vpi_driver.\n",
                       vpi_get_str(vpiType, wref));
            return(NULL);
        }
    }
    strcpy(s1, vpi_get_str(vpiType, wref));
    vpi_printf("new driver added for %s %s.\n", s1,
               vpi_get_str(vpiFullName, wref));
    return(NULL);
}
#endif

/*
 *
 */
PLI_INT32 pli_cosim(void)
{
    vpiHandle href, iter, mhref;
    vpiHandle addrref, dataref, fcref, actionref;
    int numargs, inst_id;

    //vpi_printf("pli_cosim()\n");
    
    href = vpi_handle(vpiSysTfCall, NULL); 
    if (href == NULL) {
        vpi_printf("** ERR: $pli_cosim PLI 2.0 can't get systf call handle\n");
        return(0);
    }

    mhref = vpi_handle(vpiScope, href);

    if (vpi_get(vpiType, mhref) != vpiModule)
        mhref = vpi_handle(vpiModule, mhref); 

//    inst_id = getadd_inst_id(mhref);
    (void)inst_id;
    
    iter = vpi_iterate(vpiArgument, href);

    numargs = vpi_get(vpiSize, iter);
    if (numargs != 4) {
        vpi_printf("pli_cosim() numargs=%d\n", numargs);
        vpi_printf("** ERR: $pli_cosim missing args\n");
        return(0);
    }

    /*
      reg [22:0] cosim_addr;
      reg [31:0] cosim_data;
      reg [2:0] cosim_fc;
      reg [2:0] cosim_action;
    */
    addrref = vpi_scan(iter);
    dataref = vpi_scan(iter);
    fcref = vpi_scan(iter);
    actionref = vpi_scan(iter);

    if (addrref == NULL || dataref == NULL || fcref == NULL ||
        actionref == NULL)
    {
        vpi_printf("**ERR: $pli_cosim bad args\n");
        return(0);
    }

    unsigned int addr, data;
    s_vpi_value tmpval, outval;
    int action;

    // input
    tmpval.format = vpiIntVal; 
    vpi_get_value(addrref, &tmpval);
    addr = tmpval.value.integer;
    (void)addr;
    
    tmpval.format = vpiIntVal; 
    vpi_get_value(dataref, &tmpval);
    data = tmpval.value.integer;

    tmpval.format = vpiIntVal; 
    vpi_get_value(actionref, &tmpval);
    action = tmpval.value.integer;

    if (action >= 4 && action < 10) {
        //if (cpu_trace) vpi_printf("pli_cosim() finish rw; %x\n", data);
        rw_value = data;
        finish_rw();
    }

    if (action == 10) {
        vpi_printf("pli_cosim() trace %d\n", data);
        cpu_trace = data;
    }
    
    run_sm();

    // output
    static vpiHandle addr_aref, data_aref, fc_aref, action_aref;
    
#ifdef __CVER__xxx
    if (addr_aref == 0) {
        if ((addr_aref = get_vpi_driver(addrref)) == NULL)
            addr_aref = vpi_put_value(addrref, NULL, NULL, vpiAddDriver);
    }
    if (data_aref == 0) {
        if ((data_aref = get_vpi_driver(dataref)) == NULL)
            data_aref = vpi_put_value(dataref, NULL, NULL, vpiAddDriver);
    }
    if (fc_aref == 0) {
        if ((fc_aref = get_vpi_driver(fcref)) == NULL)
            fc_aref = vpi_put_value(fcref, NULL, NULL, vpiAddDriver);
    }
    if (action_aref == 0) {
        if ((action_aref = get_vpi_driver(actionref)) == NULL)
            action_aref = vpi_put_value(actionref, NULL, NULL, vpiAddDriver);
    }
#else
    addr_aref = addrref;
    data_aref = dataref;
    fc_aref = fcref;
    action_aref = actionref;
#endif

    switch (state) {
    case S_PENDING_RW:
    case S_WAIT_RW:
        if (rw_read) {
            // read
            switch (rw_size) {
            case 1: action = 1; break;
            case 2: action = 2; break;
            case 4: action = 3; break;
            }
        } else {
            // write
            switch (rw_size) {
            case 1: action = 4; break;
            case 2: action = 5; break;
            case 4: action = 6; break;
            }
        }
        break;
    default:
        action = 0;
        break;
    }

    //if (action) vpi_printf("pli_cosim() action %d, fc %d\n", action, g_fc);
    
    outval.format = vpiIntVal;
    outval.value.integer = rw_addr;
    vpi_put_value(addr_aref, &outval, NULL, vpiNoDelay);

    outval.format = vpiIntVal;
    outval.value.integer = action;
    vpi_put_value(action_aref, &outval, NULL, vpiNoDelay);

    if (action) {
        outval.format = vpiIntVal;
        outval.value.integer = rw_write;
        vpi_put_value(data_aref, &outval, NULL, vpiNoDelay);

        outval.format = vpiIntVal;
        outval.value.integer = g_fc;
        vpi_put_value(fc_aref, &outval, NULL, vpiNoDelay);
    }

    vpi_free_object(iter);
    vpi_free_object(mhref);
//    vpi_free_object(addrref);
//    vpi_free_object(dataref);
//    vpi_free_object(fcref);
//    vpi_free_object(actionref);

    return(0);
}
#endif

#ifdef __TEST__
int main() {
    for (int c = 0; c < 1000; c++) {
        run_sm();
        if (state == S_PENDING_RW) {
            printf("serving pending rw %08x\n", rw_addr);
            switch (rw_addr) {
            case 0: rw_value = 0x00001000; break;
            case 4: rw_value = 0x00ef00d0; break;
            case 0x00ef00d0:
                rw_value = 0x3e7c0003;
                if (rw_size == 2) rw_value = 0x3e7c;
                break;
            }
            finish_rw();
            usleep(1000);
        }
    }

    finish();
}
#endif

#ifdef __CVER__
/*
 * register all vpi_ PLI 2.0 style user system tasks and functions
 */

/* use predefined table form - could fill systf_data_list dynamically */
static s_vpi_systf_data systf_data_list[] = {
    { vpiSysTask, 0, "$pli_cosim", pli_cosim, NULL, NULL, NULL },
    { 0, 0, NULL, NULL, NULL, NULL, NULL }
};

void register_my_systfs(void)
{
    p_vpi_systf_data systf_data_p;

    systf_data_p = &(systf_data_list[0]);
    while (systf_data_p->type != 0) vpi_register_systf(systf_data_p++);
}

static void (*cosim_vlog_startup_routines[]) () =
{
    register_my_systfs, 
    0
};

/* dummy +loadvpi= boostrap routine - mimics old style exec all routines */
/* in standard PLI vlog_startup_routines table */
void cosim_vpi_compat_bootstrap(void)
{
    int i;

    for (i = 0;; i++) 
    {
        if (cosim_vlog_startup_routines[i] == NULL) break; 
        cosim_vlog_startup_routines[i]();
    }
}

void vpi_compat_bootstrap(void)
{
    cosim_vpi_compat_bootstrap();
}

void __stack_chk_fail_local(void) {}
#endif


/*
 * Local Variables:
 * indent-tabs-mode:nil
 * c-basic-offset:4
 * End:
*/
