Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4E5CF11CFEB
	for <lists+linux-bcache@lfdr.de>; Thu, 12 Dec 2019 15:34:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729766AbfLLOep (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Thu, 12 Dec 2019 09:34:45 -0500
Received: from mx2.suse.de ([195.135.220.15]:40132 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729761AbfLLOem (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 12 Dec 2019 09:34:42 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 265B9B289;
        Thu, 12 Dec 2019 14:34:41 +0000 (UTC)
To:     "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>
Cc:     "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        Shaoxiong Li <dahefanteng@gmail.com>,
        Hannes Reinecke <hare@suse.de>, Ruediger Oertel <ro@suse.com>
From:   Coly Li <colyli@suse.de>
Subject: bcache works on s390 now
Organization: SUSE Labs
Message-ID: <fdf24e85-5f91-3dd8-6199-cf60ba8e125c@suse.de>
Date:   Thu, 12 Dec 2019 22:33:56 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.2.2
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Hi folks,

After a long time effort, now bcache can work on s390 machine.

The kernel part is ready since Linux v5.4, the bcache-tools should be
updated too from,
https://git.kernel.org/pub/scm/linux/kernel/git/colyli/bcache-tools.git/

The update for bcache-tools-1.1 is necessary, it fixes a super block
checksum issue which makes kernel code treats the registering device as
broken.

I only test bcache on a machine with vendir_id: IBM/S390, not sure
whether it also works on s390x. If you have interest to deploy bcache on
s390 or other big endian machines, I will appreciate if you may offer a
result whether bcache works or not on your machine. Of cause if it does
not work, I'd like to look into the problem and try to fix them.

BTW. Since bcache-tools is not updated for quite a long time, now I
start to take the maintenance of bcache-tools. And please permit me to
thank Shaoxiong Li for contributing many useful patches.

Just for your information.
-- 

Coly Li
