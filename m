Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 865203707B8
	for <lists+linux-bcache@lfdr.de>; Sat,  1 May 2021 17:27:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230195AbhEAP16 (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Sat, 1 May 2021 11:27:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230051AbhEAP16 (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Sat, 1 May 2021 11:27:58 -0400
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA8ADC06174A
        for <linux-bcache@vger.kernel.org>; Sat,  1 May 2021 08:27:08 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id g10so1488594edb.0
        for <linux-bcache@vger.kernel.org>; Sat, 01 May 2021 08:27:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=wCSTaFd5FzZ/p3U7CDmOqPzzuwDVIuNhLBgf/EQ7cOM=;
        b=pKCPJJetYpO2fKikSpkxhjS0c4YxYOe0jliMWdoPKF1rLBFLTi4xbM4UZVM1jNnVUB
         WUMLY9yL+HnPZC5+ijJX5fbNIHpgbBYt8mnRDJIXwprfrirbnjvw6zchJOjKbXpkAD84
         D0f9RN5jLY9I1Ss0u/b/Ht10AIUqFVc53QfRiaXNWPChH5aL1iyRVVLYkcluxKX71jXK
         i+7djgcgJFrGNrEdmNyY9SMDD/7txla3/psQbStJws8NQxtoppIG5uqbgjmH1RF3AdjK
         lt9WwCyTuapSEHbt2oMM7ofN0nhExZ9NoQ8SCEnvTG5hg3DqcEi5iU10jPE5b2v27aXq
         0Wxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=wCSTaFd5FzZ/p3U7CDmOqPzzuwDVIuNhLBgf/EQ7cOM=;
        b=YJdOjAh5wW/rmy7oqjVzDac7eeCi8MObZ0YHl2i2Fmx/Z6qQNnXQqO67XT46QtvZg1
         asZ0XMybxUdDl5hMjYykLijYLd0xZ0wovoKDzQDQoPO5CZkqGPi0IalkEmaN/fQNrvjC
         sAx9ddu6OhkPYjVqDI14NmPJikoXk7BX5JEJluernvFc9BLXQyd5rfZdEqHqAaGsrwgL
         SGBG6UHYUnR0QO+c0xHs5FIIOqIjlc2B+FN0xHEToPvPsB5OGSspUhCcszMd08VAv0It
         dtEnZn9CdDBIRM05lAAsp7wKn3L7HecfIIBuhT74ARHmdhj2CXZMz71f8w1BD5rfsojG
         m9Kw==
X-Gm-Message-State: AOAM5331EGR9VVlBRpKYYf0JJO3LfdExTnTsTJdMZJ5hHAhqR/5R8ggW
        8YMdNIn1xiz83qs3FKYrr9IQ+YKNnt9i8w==
X-Google-Smtp-Source: ABdhPJz/o+GBt1XcCVkfayxnoOcONHpUF2ZoxZBGVCmrdX/gXs8uwz4eQq6YksOHynTSp274sulI1Q==
X-Received: by 2002:a05:6402:b2c:: with SMTP id bo12mr11895324edb.196.1619882827256;
        Sat, 01 May 2021 08:27:07 -0700 (PDT)
Received: from exnet.gdb.it (mob-5-90-161-227.net.vodafone.it. [5.90.161.227])
        by smtp.gmail.com with ESMTPSA id l1sm6037460edt.59.2021.05.01.08.27.06
        for <linux-bcache@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 01 May 2021 08:27:06 -0700 (PDT)
From:   Giuseppe Della Bianca <giusdbg@gmail.com>
To:     linux-bcache@vger.kernel.org
Subject: [BCACHE] Parameter setting
Date:   Sat, 01 May 2021 17:26:52 +0200
Message-ID: <3602435.kQq0lBPeGt@exnet.gdb.it>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Hi.

To set parameters I used this udev rule

/etc/udev/rules.d/70-bcache-tuning.rules

SUBSYSTEM!="block", GOTO="end_rule" 
ENV{DEVTYPE}=="partition", GOTO="end_rule" 
ACTION!="add|change", GOTO="end_rule" 
KERNEL=="bcache*", ATTR{bcache/sequential_cutoff}="300000000" 
LABEL="end_rule"



gdb


