Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A20753820AC
	for <lists+linux-bcache@lfdr.de>; Sun, 16 May 2021 21:43:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232919AbhEPTor (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Sun, 16 May 2021 15:44:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230507AbhEPTor (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Sun, 16 May 2021 15:44:47 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F068C061573
        for <linux-bcache@vger.kernel.org>; Sun, 16 May 2021 12:43:32 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id z12so4616133ejw.0
        for <linux-bcache@vger.kernel.org>; Sun, 16 May 2021 12:43:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=LqB/+V/y6t9dffNstQKxAwS2r8d1lRxqzrThgRhor4Y=;
        b=pw0/jm6+dhR6w6vOi3vxW+UzSklT33nXnB5MN98So4ZKlGhZtapSYk3Q1O+0RwtX+2
         x+l3gX2ZOc3PJlI2xoDXH6Fve1bmhlZYBE2td+cjBvpdI/mfDUsCxYmN39F2jHpIp4/r
         CT7lODJlqR44FUQwj1ONxQjih1xE17Fs0CtCvXgUFuk/+0RalQGwO/DeqAa/OBYh0WST
         PlMTw4K+DXzWpzGACtEjyo2Zz4O8WdbvZCCMho96+upM7LxJU97h/FPCjPsXE0KtJEFL
         T/fVZyKBhsSlVNlJeNLDXXNq7L3v+hJ6FH+Aa9pDiDX63AGiRpIWL/rgk4hDxcmf6yU2
         QgzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=LqB/+V/y6t9dffNstQKxAwS2r8d1lRxqzrThgRhor4Y=;
        b=fI97va+/GC3AuRNehKmRXSxOGRk0JKMD4n8h77U6uk+mYlycalC6lXtMANMicAQIz0
         THGN6au+Idz1SAEb6RGV+1zzwn6fI/cz8HpOuIisqy+GLqGsyda9AJF+o+lkq3FNT4Zm
         x2uQeBbazQNURUkeduvH4CcFY5pWiZT+zuRVZqqMky2tWuxbpIaV4EFEW+hiA+CHUJE/
         hg8akgYiLp5YblqIfIe9dMCjV0HqVCm+5KLo6Nt4PhIZr8C0CnVeI34h5XfXiFtjlKPZ
         wWbcPFxUAG2zXgjDeSnKyCMUkq/EOfzbTjkrZV4NXmaqKXWansVu9LzSwqyT2qTgc8KG
         qEBQ==
X-Gm-Message-State: AOAM5314K2TzWK3t7LbzIBmqMilcPnlSq8cVuJbPkL+j3m8BohLxrJmX
        xs8rMz5O6oCqjwa3sewIqjgWvjVnt7E=
X-Google-Smtp-Source: ABdhPJwikb+XJju5/Aoiaq83ArZkJFggKp5l03IA7nJnXOjTzmSET1Gak98aQUkArUFIx8V2QWF1bQ==
X-Received: by 2002:a17:906:36da:: with SMTP id b26mr59021608ejc.8.1621194210841;
        Sun, 16 May 2021 12:43:30 -0700 (PDT)
Received: from exnet.gdb.it (mob-5-90-221-245.net.vodafone.it. [5.90.221.245])
        by smtp.gmail.com with ESMTPSA id p13sm7326752ejr.87.2021.05.16.12.43.30
        for <linux-bcache@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 16 May 2021 12:43:30 -0700 (PDT)
From:   Giuseppe Della Bianca <giusdbg@gmail.com>
To:     linux-bcache@vger.kernel.org
Subject: [BCACHE] Forcing the PD controller to follow the disks activity time
Date:   Sun, 16 May 2021 21:42:55 +0200
Message-ID: <1786458.tdWV9SEqCh@exnet.gdb.it>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Hi.

I wrote this shell script for get a low dirty data size, and a low cache/backing devices overload.

This script sets a low or very low writeback rate for medium or medium hight disks activity time.
And set medium writeback rate for very low disks activity time.

Then some information is printed in the standard output because this script is executed every second by an applet that displays the information in the user's desktop.

P.S. If this strategy was placed inside bcache, it should set the maximum writeback rate, and the PD controller should be more aggressive with the mimum writeback.


#!/bin/bash

bkDev="sdb"
chDev="nvme"
sysBcBase="/sys/block"

bcDev=`find /sys/block/$bkDev/ | grep -e 'bcache[0-9,a-z,A-Z]\{1,\}' | sed -e 's/.*\///'`
sysBcDev="$sysBcBase/$bcDev/bcache"

bkUsage="0"
chUsage="0"

echo -e "Device: $bcDev"


    while read diskLine
    do
#echo $diskLine >> /tmp/grrr.txt
	read diskName diskUsage  < <(echo $diskLine | sed -e 's/\([0-9,a-z]\{1,\}\).* \([0-9]\{1,\}\)/\1 \2/')

	if [ $(expr "$diskName" : "$bkDev") != 0 ]; then
	    bkUsage=$diskUsage
    	elif [ $(expr "$diskName" : "$chDev") != 0 ]; then
	    chUsage=$diskUsage
	fi
	
	echo -e "Device: $diskName\tUsage: $diskUsage"
    done < <(iostat -dmx --dec=0 -y 1 1 | grep -e "$bkDev\|$chDev")


attWBRateMin=$(cat $sysBcDev/writeback_rate_minimum)
newWBrateMin=$attWBRateMin

if [ "$bkUsage" -le "10" ] && [ "$chUsage" -le "10" ]; then
    if [ "$attWBRateMin" -lt "50000" ]; then
	newWBrateMin=50000;
    fi
elif [ "$bkUsage" -le "20" ] && [ "$chUsage" -le "20" ]; then
    newWBrateMin=10000;
elif [ "$bkUsage" -le "40" ] && [ "$chUsage" -le "40" ]; then
    newWBrateMin=100;
elif [ "$attWBRateMin" -ge "10" ]; then
    newWBrateMin=10;
fi

if [ "$newWBrateMin" != "$attWBRateMin" ]; then echo $newWBrateMin > $sysBcDev/writeback_rate_minimum; fi

echo -e "bkUsage: $bkUsage\tchUsage: $chUsage"
echo -en "Dirty: $(cat $sysBcDev/dirty_data)"
echo -en "   Rate: $(cat $sysBcDev/writeback_rate)"
echo -en "   R.Min: $(cat $sysBcDev/writeback_rate_minimum)\n"



echo -e "$(cat $sysBcDev/writeback_rate_debug)"









