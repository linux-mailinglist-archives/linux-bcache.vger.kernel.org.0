Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF3827797FD
	for <lists+linux-bcache@lfdr.de>; Fri, 11 Aug 2023 21:58:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234758AbjHKT6G (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Fri, 11 Aug 2023 15:58:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229447AbjHKT6F (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 11 Aug 2023 15:58:05 -0400
X-Greylist: delayed 2300 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 11 Aug 2023 12:58:04 PDT
Received: from mail.axxess.co.za (mail.axxess.co.za [197.242.159.197])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 569A3171F
        for <linux-bcache@vger.kernel.org>; Fri, 11 Aug 2023 12:58:03 -0700 (PDT)
X-Default-Received-SPF: pass (skip=loggedin (res=PASS)) x-ip-name=102.130.113.94; envelope-from=<josias@axxess.co.za>;
Message-ID: <e37842e3-8b7e-4849-9974-808e8ae038fd@axxess.co.za>
Date:   Fri, 11 Aug 2023 21:19:42 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
To:     linux-bcache@vger.kernel.org
Content-Language: en-CA
From:   Josias Wolhuter <josias@axxess.co.za>
Subject: bcache attach
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Qnum: 76083775
X-Authenticated-User: josias@axxess.co.za 
X-Spam-Status: No, score=0.8 required=5.0 tests=BAYES_50,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Hi
Sorry to bug you (pun intended)
I get this
[root@ivan ~]# echo b43b13cf-32b1-4e5a-af7d-27b6d246662d 
 >/sys/block/bcache0/bcache/attach
-bash: echo: write error: No such file or directory

but

bcache-super-show /dev/nvme1n1p1
***
cset.uuid		b43b13cf-32b1-4e5a-af7d-27b6d246662d


bcache-super-show /dev/sdb1
***
dev.data.cache_state	0 [detached]

cset.uuid		00000000-0000-0000-0000-000000000000



One unusual thing I did was to set the cache device block size 
differently/seperately from the backing device.  but dont see mention of 
such a difference in the manual or online

Cheers
