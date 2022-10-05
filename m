Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 90C9A5F50C3
	for <lists+linux-bcache@lfdr.de>; Wed,  5 Oct 2022 10:25:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230001AbiJEIZI (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 5 Oct 2022 04:25:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229996AbiJEIYd (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 5 Oct 2022 04:24:33 -0400
X-Greylist: delayed 508 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 05 Oct 2022 01:24:22 PDT
Received: from wtwrp.de (wtwrp.de [IPv6:2a01:4f8:231:40ed::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 088C64055E
        for <linux-bcache@vger.kernel.org>; Wed,  5 Oct 2022 01:24:21 -0700 (PDT)
Message-ID: <5ff94948-9406-9b86-2ab3-db74fcb44d00@ezl.re>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wtwrp.de; s=dkim;
        t=1664957751;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type;
        bh=uBDtKSMA63r719Ro6kv62SP8Xn1bolXrcGVOwoKFmlU=;
        b=U+Lgc7X7Y6nlmtAVSr26UCBIGFzx9NZLzdHgbnpy/NS9FpurTEdl46vZOFtwmg50EKAnvi
        scmyNMCL2TkIydw3YKAOWMxmcN+ZiP4eEEqt3uB31Wk/rjGEexa2ec9hEs165Wx3GgKOp+
        ZekJbtgeadTajeYNYTQV1vZaXLAio6S1BvK7+GrDJYmjSYTIY749euC9hsoISmHJo+JV6x
        yQawaAmRhN/yu7+33rQXtf+4hhr8lWnsGdVKfHAt7GZnuoBlSVVDNWJMvdVT4uNWArDLYv
        w0n0+Ma6svQZr2br6uWvRONIgrDWrVp8FkWiiPjetesfiT81aimsuJgVe1BMeg==
Date:   Wed, 5 Oct 2022 10:15:47 +0200
MIME-Version: 1.0
Content-Language: en-US
To:     linux-bcache@vger.kernel.org
From:   Cobra_Fast <cobra_fast@wtwrp.de>
Subject: Feature Request - Full Bypass/Verify Mode
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------wqa78htvwTuVpUwKgqO6UgO0"
Authentication-Results: wtwrp.de;
        auth=pass smtp.mailfrom=cobra_fast@wtwrp.de
X-Spamd-Bar: -----------
X-Spam-Status: No, score=0.6 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------wqa78htvwTuVpUwKgqO6UgO0
Content-Type: multipart/mixed; boundary="------------qYa6NCE9BxMS40d5AcXOH0wl";
 protected-headers="v1"
From: Cobra_Fast <cobra_fast@wtwrp.de>
To: linux-bcache@vger.kernel.org
Message-ID: <5ff94948-9406-9b86-2ab3-db74fcb44d00@ezl.re>
Subject: Feature Request - Full Bypass/Verify Mode

--------------qYa6NCE9BxMS40d5AcXOH0wl
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

R3JlZXRpbmdzLA0KDQpJIGFtIHVzaW5nIGJjYWNoZSBpbiBjb25qdW5jdGlvbiB3aXRoIFNu
YXBSQUlELCB3aGljaCB3b3JrcyBvbiB0aGUgDQpGUy1sZXZlbCwgYW5kIEkgaGF2ZSBub3Rp
Y2VkIHRoYXQgcGFyaXR5IHN5bmNzIGFzIHdlbGwgYXMgc2NydWJzIHJlYWQgDQpkYXRhIGZy
b20gdGhlIGNhY2hlIHJhdGhlciB0aGFuIHRoZSBiYWNraW5nIGRldmljZS4gVGhpcyBwcm9i
YWJseSBub3QgYSANCnByb2JsZW0gd2hlbiBjcmVhdGluZyBwYXJpdHkgZm9yIG5ldyBmaWxl
cywgYnV0IGNvdWxkIGJlIGEgcHJvYmxlbSB3aGVuIA0KcnVubmluZyBzY3J1YnMsIGFzIHRo
ZSBwYXJpdHkgaXMgbmV2ZXIgY2hlY2tlZCBhZ2FpbnN0IGRhdGEgb24gZGlzayANCnNpbmNl
IGJjYWNoZSBoaWRlcyBpdC4NCg0KSSB3b3VsZCB0aGVyZWZvcmUgdmVyeSBtdWNoIGxpa2Ug
YSBjYWNoZV9tb2RlIHRoYXQgd291bGQgYnlwYXNzIGFueSBhbmQgDQphbGwgcmVhZHMsIHRo
YXQgY2FuIGJlIGVuYWJsZWQgZm9yIHRoZSBkdXJhdGlvbiBvZiBhIFNuYXBSQUlEIHN5bmMg
b3IgDQpzY3J1Yi4gRm9yIHdyaXRlcyBJIHN1cHBvc2UgdGhpcyBtb2RlIHNob3VsZCBhY3Qg
dGhlIHNhbWUgYXMgIm5vbmUiLg0KDQpUaGlzIG9wcG9ydHVuaXR5IGNvdWxkIGJlIHRha2Vu
IHRvIHZlcmlmeSBkYXRhIG9uIGNhY2hlIGFzIHdlbGw7IHJlYWQgDQpmcm9tIGJvdGggYmFj
a2luZyBhbmQgY2FjaGUgYW5kIGludmFsaWRhdGUgdGhlIGNhY2hlIHBhZ2UgaWYgaXQgZGlm
ZmVycyANCmZyb20gdGhlIGJhY2tpbmcgZGF0YSwgd2hpbGUgc2F0aXNmeWluZyB0aGUgYWN0
dWFsIHJlYWQgZnJvbSBiYWNraW5nIGluIA0KYW55IGNhc2UuDQoNClBlcmhhcHMgc29tZXRo
aW5nIGxpa2UgdGhpcyBpcyBhbHJlYWR5IHBvc3NpYmxlIGFuZCBJJ20ganVzdCBub3Qgc2Vl
aW5nIGl0Pw0KSSBrbm93IEkgY2FuIGRldGFjaCBiYWNraW5nIGRldmljZXMsIGJ1dCB0byBt
eSB1bmRlcnN0YW5kaW5nIHRoYXQgYWxzbyANCmludmFsaWRhdGVzIGFsbCBpdHMgY2FjaGVk
IHBhZ2VzIGFuZCBJIHdvdWxkIG9idmlvdXNseSBsaWtlIHRvIGtlZXAgdGhlbSANCmZvciB0
aGlzIHB1cnBvc2UuDQoNCkxvb2tpbmcgZm9yd2FyZCB0byB5b3VyIG9waW5pb25zLA0KQmVz
dCByZWdhcmRzLA0KQW5keQ0K

--------------qYa6NCE9BxMS40d5AcXOH0wl--

--------------wqa78htvwTuVpUwKgqO6UgO0
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

wsF5BAABCAAjFiEE1WY5pamBRKDWIBbjRka/iREL/PMFAmM9PTMFAwAAAAAACgkQRka/iREL/PNw
rw//XLPEN72nj8c0f9qm9SY6VZ0yF7mopQK4Q2Sm+u4QLFJb+7ldQvsMrk2YJV8Cz4PKjSBfOJYN
08FY5Ed1Vl54lSbkte/8/VEB7EQwL4vMkNWQ2OK3KXq/fEz0ithB5Oe9ETI9M5KEWaO1TiUtNuAF
nSO/q/nHlS+ACWyWJBm8edrMRNLqEvSzvDsqCQdQaEFiPj8tQBfD9ucbgQEdUxmpWVLosuF93/E3
O/cizNCycKGMxuXqPP9y/O75qICqXnKwAYnjvlFtlN02ovbMPxu0z5s/40zPuy4FOElQhc01B4+s
KPShvsDWcbLXbRuzuFh5qiHTJELtzX8ETSgtbeuzb9KqPBd7HY8Ms68Kq/d/JQZLakKAPFGWKqXO
W6/RNkMFBAC1NpnFg9YgoJO8G2ea4xWwZw7xxGaT+93LXmJkrr5B6ADeksvx5uZDa02isY7+qp0s
qlFlUQVYLTx53Kx/rxWXXovXa+T00r7cSvJVjAjSyiPOMejkyYzAoZ03xmK3W55rcU49D9jO+rDD
zi5P6H1Di7UQAUIuksDMi9bEkTP1VtVYBQ3Z2DtfDujSzT6YXNnXUS2kVemf4UgVaWr63xlFf7OJ
xbqdvHu3l3bT3oqlcm6rUk+fJpSd1iL3odBOiTxC+LLxTTdCLVqIhTS92FOTTxLt2N2vIUCYfmHE
WhU=
=5Lpv
-----END PGP SIGNATURE-----

--------------wqa78htvwTuVpUwKgqO6UgO0--
