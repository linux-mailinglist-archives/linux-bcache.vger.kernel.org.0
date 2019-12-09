Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ECF91117909
	for <lists+linux-bcache@lfdr.de>; Mon,  9 Dec 2019 23:07:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726614AbfLIWHA (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 9 Dec 2019 17:07:00 -0500
Received: from mail-wm1-f44.google.com ([209.85.128.44]:53030 "EHLO
        mail-wm1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726483AbfLIWHA (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 9 Dec 2019 17:07:00 -0500
Received: by mail-wm1-f44.google.com with SMTP id p9so1019283wmc.2
        for <linux-bcache@vger.kernel.org>; Mon, 09 Dec 2019 14:06:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=ZHdGwqxnDOPrs3xiefzN24WC7Xz660W+P2bIIE5xEk8=;
        b=DfXCGg3QoAgbOVa56GK32epApyGsj4tkHghCJ8rVCommgGSKM3DFmVBSnndLJqMiC4
         ocnqGfPs+oJEl/XfvtHjFk0+OicNnHGHT4gwNbEqAc21A+iUM4xHdv6HKvSHY6FVHaRJ
         Qbxup4AF+aNKKeVMOxj+S4i9Gbm2WzdpS8WfKwBZNa9gNf4YvDIHHQU+PDeWJS10ZHvu
         18iombkpVK08do67Qc1SvpIrcfaZ2C+GAgJ9D+EaN8qsWh4liaBs4RlgZYXHeniDkf12
         ap46gdmTCicreTsvkCQovRgvWm3q8+ocTHrE4codZLp2o4zLlkCkdgTZmPQr4dDAyvEE
         v6dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=ZHdGwqxnDOPrs3xiefzN24WC7Xz660W+P2bIIE5xEk8=;
        b=JgKPQfc6uAg35jQEi0yLInFC9KHKbW3ncEWIJWEI48eiQEAYE+DsEbckKN6Hhqgl0z
         SsXJ20TP5fwkzDZze8GQybrU3M1Vxdp6Q/4GbrFzwSj8ITXN2t9MHLU6SR7C1CowPcZ1
         UDLjUeQX4CmEEN+fMmgUhP3dsclATPYUo5T/1djKt/OP2EwuR+1H9wVug3e54iwILMaB
         bosU3e+01Alm8nMZhHXuO+bNx5uC7oWP2bUVGIQlF3PQfx+LBc8/wd7uC1on62VszVJS
         NN8SZ/dIIBt/VlIMGMdbJdBLB6s/OPbSBPVKxeG5pgNnME4qwM6bPX0JYBrt/zHZtD0I
         Iiqw==
X-Gm-Message-State: APjAAAXm4rzlzmmUZl+Yjg0QH8zjriinsEnSEIqcf/c2UDmGckVYF1WH
        NNvERKr5h2558VB9KqTSUH4VyZ1bXjS9GXHx+RcU8GjsrQ8=
X-Google-Smtp-Source: APXvYqxOZlNMFipCwDWFYIT6teworYa4/qBe6XL3N2awpWK3+qATql97s4OwgPec5PjcqQtx1m35eZhEp9OmoKxHcJ0=
X-Received: by 2002:a7b:c051:: with SMTP id u17mr1283601wmc.174.1575929218323;
 Mon, 09 Dec 2019 14:06:58 -0800 (PST)
MIME-Version: 1.0
From:   Nathan Dehnel <ncdehnel@gmail.com>
Date:   Mon, 9 Dec 2019 16:06:46 -0600
Message-ID: <CAEEhgEtXKoQymHyS278GvE=95jNiW71sb1bz_-2AfOkDPp0dMw@mail.gmail.com>
Subject: Trying to attach a cache drive gives "invalid argument"
To:     linux-bcache@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

root@gentooserver / # echo 45511b33-6bb8-42d5-a255-3de1749f8dda >
/sys/block/bcache0/bcache/attach
-bash: echo: write error: Invalid argument

How should I fix this?
