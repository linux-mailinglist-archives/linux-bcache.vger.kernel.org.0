Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6F30231C92
	for <lists+linux-bcache@lfdr.de>; Wed, 29 Jul 2020 12:18:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726385AbgG2KSY convert rfc822-to-8bit (ORCPT
        <rfc822;lists+linux-bcache@lfdr.de>); Wed, 29 Jul 2020 06:18:24 -0400
Received: from mailer21-9.incnets.com ([210.6.92.62]:49060 "EHLO
        mailer21-9.incnets.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726367AbgG2KSX (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 29 Jul 2020 06:18:23 -0400
X-Greylist: delayed 578 seconds by postgrey-1.27 at vger.kernel.org; Wed, 29 Jul 2020 06:18:20 EDT
Received: from outguard14.hkbn.net (outguard14.hkbn.net [203.80.96.171])
        by mailer21.incnets.com (Postfix) with ESMTP id B85411D47
        for <linux-bcache@vger.kernel.org>; Wed, 29 Jul 2020 18:05:24 +0800 (CST)
Received: from localhost (unknown [127.0.0.1])
        by IMSVA (Postfix) with SMTP id A5EFF18046
        for <linux-bcache@vger.kernel.org>; Wed, 29 Jul 2020 18:08:41 +0800 (HKT)
X-IMSS-HAND-OFF-DIRECTIVE: mailer2.incnets.com:25
Received: from outguard14.hkbn.net (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2A1AA18049
        for <linux-bcache@vger.kernel.org>; Wed, 29 Jul 2020 18:08:40 +0800 (HKT)
Received: from smtp-out1.hkbn.net (unknown [203.186.94.55])
        by outguard14.hkbn.net (Postfix) with ESMTP
        for <linux-bcache@vger.kernel.org>; Wed, 29 Jul 2020 18:08:40 +0800 (HKT)
Received: from mail.wonghome.net (119247088063.ctinets.com [119.247.88.63])
        by smtp-out1.hkbn.net (Postfix) with ESMTP id E019A206
        for <linux-bcache@vger.kernel.org>; Wed, 29 Jul 2020 18:08:38 +0800 (CST)
Received: from [10.10.10.3] (redcat.wonghome.net [10.10.10.3])
        (using TLSv1.3 with cipher AEAD-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.wonghome.net (Postfix) with ESMTPSA id 91ED11699B2
        for <linux-bcache@vger.kernel.org>; Wed, 29 Jul 2020 18:08:38 +0800 (HKT)
To:     linux-bcache@vger.kernel.org
From:   johnw <johnw.mail@gmail.com>
Subject: Add another cache device to existing bcache disk
Autocrypt: addr=johnw.mail@gmail.com; prefer-encrypt=mutual; keydata=
 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
Message-ID: <d516860e-f2b4-0c83-0199-6d126b5ba710@gmail.com>
Date:   Wed, 29 Jul 2020 18:08:38 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Content-Language: en-GB
X-TM-AS-GCONF: 00
X-TM-AS-Product-Ver: IMSVA-9.1.0.1817-8.6.0.1013-25570.006
X-TM-AS-Result: No--3.474-9.9-31-10
X-imss-scan-details: No--3.474-9.9-31-10
X-TMASE-Version: IMSVA-9.1.0.1817-8.6.1013-25570.006
X-TMASE-Result: 10--3.474200-10.000000
X-TMASE-MatchedRID: 9PYyOT2Ifr44tGBQPT0ZobbQFsbjObJeL1eX+z9B1QxCNbvgrCxK9JAa
        Np2uvngxWgjwuEzFWtFtHxr/k6LH0tQEgQzg5Dp4+CjwEqX1p7mpZoxavGZhjpkd+ko3Vgxl2PV
        rCHJ8LhZC3bjvSDu952T7EEUFzHhko8WMkQWv6iUDpAZ2/B/BlrlQQ96R+TwuavP8b9lJtWr6C0
        ePs7A07dZdeSwAMNXyvLOxFDD0IVw3sqQmXRv6XDb4obBOQpE8fmMN9zVzY7u3JhPJS1Cctq1Sm
        glWZESJwyAvip+0hl4BSJ7tpiI93Ab1I25kJB4g+lWgSCOtszjq1b4yifE4j4x3HGtyXEyVq9ex
        ZkCula1LDBwYotNgRw==
X-TMASE-SNAP-Result: 1.821001.0001-0-1-12:0,22:0,33:0,34:0-0
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Hi, I have existing bcache0 disk/device(1 backing disk, and 1 cache
disk), is there any way to add another cache disk to the bcache0
disk/device?

Do I need detach the existing cache disk first?

Where I register the cache2 disk to the bcache0 device, I see the error
message as below in the dmesg log

bcache: register_bcache() error : device already registered
[  308.037636] bcache: bch_cached_dev_attach() Can't attach sda: already
attached
[  453.414692] bcache: __cached_dev_store() Can't attach
17ac5b8f-d787-4e46-96b7-c5ee53eb6d19
               : cache set not found

Thanks.

-- 
Key fingerprint: CDB3 6C62 254B C088 1E5D DD32 182C 97DB CF2C 80AC


